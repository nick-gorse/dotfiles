#!/usr/bin/env zsh
echo "in qt.zlogin"
if [[ "${GHOSTTY_QUICK_TERMINAL}" == 1 ]]; then
    typeset -g QT_RUN=$(echo "$(which nvim) --server 127.0.0.1:7777 --remote-ui")
fi
