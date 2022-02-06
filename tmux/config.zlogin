#!/usr/bin/zsh
if [[ -n "$TMUX" ]]; then
	printf -v SESS_NAME `tmux display-message -p "#S"`
    export SESS_NAME
	# if [[ -e "$HOME/.virtualenvs/${SESS_NAME}/bin/activate" ]] && [[ $- =~ i ]]; then
	#     source $HOME/.virtualenvs/$SESS_NAME/bin/activate >| $HOME/jup.log 2>&1
	#     alias deactivate=exit
	#     alias workon=exit
	# fi

	case "$SESS_NAME" in
	  jupyter)
              # pyenv activate jupyter
			# 		  	export JUPYTER_CONFIG_DIR=$HOME/.pyenv/versions/jupyter/etc/jupyter
			# jupyter_run
	    ;;
	  streamlit)
		  	pyenv activate streamlit
		;;
	  *)
	    ;;
	esac
fi
