#!/usr/bin/zsh

if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [ -n "$LC_TMUX" ] && [[ $- =~ i ]]; then 
    tmux has-session -t ${LC_TMUX} > /dev/null 2>&1 || tmux -2 new-session -s "$LC_TMUX" -d
	tmux attach -t "$LC_TMUX"
fi

