#!/usr/bin/zsh

unset SESS_NAME

# if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [ -n "$LC_TMUX" ] && [[ $- =~ i ]]; then
# 	# tmux -2 -CC new-session -A -s "$LC_TMUX"
#  	if ! tmux has-session -t ${LC_TMUX}; then
# 		tmux -2 new-session -d -s "$LC_TMUX" -d \; \
# 			split-window -v \;
# 	fi
# 	# tmux send-keys -t 'Main'
# 	tmux -CC attach -t $LC_TMUX
# 	exit
# fi

