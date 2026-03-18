#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${1:-}"
PORT="${2:-7777}"
NVIM_BIN="${3:-}"

if [[ -z "$TARGET_USER" ]]; then
  echo "Usage: sudo $0 <target-user> [port] [nvim-bin]"
  echo 'Example: sudo ./deploy-nevoid.sh ngorse 7777 /home/ngorse/.local/share/mise/shims/nvim'
  exit 1
fi

if ! id "$TARGET_USER" >/dev/null 2>&1; then
  echo "User does not exist: $TARGET_USER" >&2
  exit 1
fi

USER_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
USER_UID="$(id -u "$TARGET_USER")"
USER_CONFIG_DIR="$USER_HOME/.config/systemd/user"

if [[ -z "$NVIM_BIN" ]]; then
  if [[ -x "/opt/usr/bin/nvim" ]]; then
    NVIM_BIN="/opt/usr/bin/nvim"
  elif sudo -u "$TARGET_USER" bash -lc 'command -v nvim >/dev/null 2>&1'; then
    NVIM_BIN="$(sudo -u "$TARGET_USER" bash -lc 'command -v nvim')"
  else
    echo "Could not find nvim for user $TARGET_USER." >&2
    echo "Pass the full path as the third argument." >&2
    exit 1
  fi
fi

if [[ ! -x "$NVIM_BIN" ]]; then
  echo "nvim binary is not executable: $NVIM_BIN" >&2
  exit 1
fi

PROXY_BIN="/usr/lib/systemd/systemd-socket-proxyd"
if [[ ! -x "$PROXY_BIN" ]]; then
  PROXY_BIN="$(command -v systemd-socket-proxyd || true)"
fi

if [[ -z "$PROXY_BIN" || ! -x "$PROXY_BIN" ]]; then
  echo "Could not find systemd-socket-proxyd." >&2
  exit 1
fi

mkdir -p "$USER_CONFIG_DIR"
chown -R "$TARGET_USER:$TARGET_USER" "$USER_HOME/.config"

cat >"$USER_CONFIG_DIR/nevoid.socket" <<EOF
[Unit]
Description=Neovim RPC socket (on-demand) on 127.0.0.1:${PORT}

[Socket]
ListenStream=127.0.0.1:${PORT}
NoDelay=true
SocketMode=0600
Service=nevoid-proxy.service

[Install]
WantedBy=sockets.target
EOF

cat >"$USER_CONFIG_DIR/nevoid-proxy.service" <<EOF
[Unit]
Description=Socket proxy: 127.0.0.1:${PORT} -> unix:%t/nevoid/nvim.sock
After=nevoid-backend.service

[Service]
ExecStartPre=/usr/bin/systemctl --user start nevoid-backend.service
ExecStart=${PROXY_BIN} --exit-idle-time=600 %t/nevoid/nvim.sock

Restart=on-failure
RestartSec=1s

NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
EOF

cat >"$USER_CONFIG_DIR/nevoid-backend.service" <<EOF
[Unit]
Description=Neovim RPC backend (headless)

[Service]
Type=simple

RuntimeDirectory=nevoid
RuntimeDirectoryMode=0700

ExecStartPre=/bin/rm -f %t/nevoid/nvim.sock
ExecStart=${NVIM_BIN} --headless --listen %t/nevoid/nvim.sock

Restart=on-failure
RestartSec=1s

TimeoutStopSec=10s
KillSignal=SIGTERM

NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
EOF

chown "$TARGET_USER:$TARGET_USER" \
  "$USER_CONFIG_DIR/nevoid.socket" \
  "$USER_CONFIG_DIR/nevoid-proxy.service" \
  "$USER_CONFIG_DIR/nevoid-backend.service"

loginctl enable-linger "$TARGET_USER"

USER_BUS_DIR="/run/user/$USER_UID"
if [[ ! -d "$USER_BUS_DIR" ]]; then
  echo "Creating runtime systemd session by starting user@${USER_UID}.service"
  systemctl start "user@${USER_UID}.service"
fi

sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="/run/user/$USER_UID" systemctl --user daemon-reload
sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="/run/user/$USER_UID" systemctl --user reset-failed nevoid.socket nevoid-proxy.service nevoid-backend.service || true
sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="/run/user/$USER_UID" systemctl --user enable --now nevoid.socket

echo
echo "Installed successfully for user: $TARGET_USER"
echo "Port: $PORT"
echo "nvim: $NVIM_BIN"
echo
echo "Check status with:"
echo "  sudo -u $TARGET_USER XDG_RUNTIME_DIR=/run/user/$USER_UID systemctl --user status nevoid.socket nevoid-proxy.service nevoid-backend.service"
echo
echo "Test locally on the host with:"
echo "  nc -vz 127.0.0.1 $PORT"
