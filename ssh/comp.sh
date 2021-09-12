#!/usr/local/bin/zsh
if [[ "{$(cat $HOME/.ssh/config)[0]}" == "{$(cat $HOME/.dotfiles/ssh/config)[0]}" ]]; then
    echo "yes"
fi
