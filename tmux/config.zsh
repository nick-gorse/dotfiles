if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [ -n "$LC_TMUX" ] && [[ $- =~ i ]]; then 
    tmux -CC new -A -s $LC_TMUX
	#tmux -CC attach-session -t ssh || tmux -CC new-session -s ssh 
    unset LC_TMUX
	exit 
fi
