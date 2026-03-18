#export VIM=$HOME/.dotfiles/nvim
#export VIMRUNTIME=$HOME/.config/nvim/runtime
#export NVIM_SERVER="${XDG_CACHE_HOME:-$HOME/.cache}/nvim/server.socket"

# Don't clobber values already injected by ssh.conf or the environment.
# On local: these default to LOCAL / 7777.
# On remote hosts: ssh.conf injects NVIM_NAME=<host> and NVIM_SERVER=127.0.0.1:<port>
# before the shell starts, so :- means those values are preserved.
export NVIM_NAME="${NVIM_NAME:-LOCAL}"
export NVIM_SERVER="${NVIM_SERVER:-127.0.0.1:7777}"
export NVIM_BACKUP_DIR="$HOME/.local/share/nvim/backups"

# Stamp kitty window user vars so nvim_panel.py kitten can read host identity
# without relying on os.environ (kittens run in an isolated subprocess).
# Fires once on first prompt, then removes itself.
if [[ "$LC_TERMINAL" == "kitty" ]] && command -v kitten >/dev/null 2>&1; then
    _stamp_kitty_nvim_vars() {
        kitten @ set-user-var NVIM_NAME "${NVIM_NAME}" 2>/dev/null
        kitten @ set-user-var NVIM_SERVER "${NVIM_SERVER}" 2>/dev/null
        add-zsh-hook -d precmd _stamp_kitty_nvim_vars
    }
    add-zsh-hook precmd _stamp_kitty_nvim_vars
fi
