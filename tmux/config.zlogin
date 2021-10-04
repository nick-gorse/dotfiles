#!/usr/bin/zsh
if [[ -n "${TMUX+set}" ]]; then
	# export SESS_NAME=`[[ -n "${TMUX+set}" ]] && tmux display-message -p "#S"`
	export SESS_NAME=`tmux display-message -p "#S"`
	if [ -n "$TMUX" ] && [[ -n "$SESS_NAME" && -e "$HOME/.virtualenvs/${SESS_NAME}/bin/activate" ]] && [[ $- =~ i ]]; then
	    source $HOME/.virtualenvs/$SESS_NAME/bin/activate
	    alias deactivate=exit
	    alias workon=exit
	fi

	if [[ "$SESS_NAME" == "jupyter" ]]; then
	    JUP_PID=`cat $HOME/.jup_pid`
	    if ! ps -o pid --no-headers -fp $JUP_PID > /dev/null 2>&1; then
	#        source $HOME/.virtualenvs/jupyter/bin/activate >| $HOME/jup.log 2>&1
	        $HOME/.virtualenvs/jupyter/bin/python $HOME/.virtualenvs/jupyter/bin/jupyter-lab &
	        echo $! >| $HOME/.jup_pid
	        tail -f $HOME/jup.log
	    fi
	fi
fi
