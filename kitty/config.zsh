#!/usr/bin/env zsh
#
if test -n "$KITTY_INSTALLATION_DIR"; then
    if ! command -v kitty >/dev/null 2>&1; then
        export KITTY_SHELL_INTEGRATION="enabled"
        autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
        kitty-integration
        unfunction kitty-integration
    fi
fi

if [[ -z "$DOTFILES/kitty/logo/${$(hostname):l}.png" ]]; then
    KITTY_LOGO_FILE=$DOTFILES/kitty/logo/default.png
else
    KITTY_LOGO_FILE=$DOTFILES/kitty/logo/${$(hostname):l}.png
fi
export KITTY_LOGO_FILE

_change_kitty_logo () {
   [[ -n $KITTY_WINDOW_ID ]] && kitten @ set-window-logo --match id:$KITTY_WINDOW_ID $KITTY_LOGO_FILE
}

if [[ -n $KITTY_WINDOW_ID ]]; then
   autoload -Uz add-zsh-hook
   add-zsh-hook precmd _change_kitty_logo
fi
