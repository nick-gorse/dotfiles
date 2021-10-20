#!/usr/bin/zsh
if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [ -n "$LC_TMUX" ] && [[ $- =~ i ]]; then 
    tmux -CC new -A -s $LC_TMUX
	exit 
fi
