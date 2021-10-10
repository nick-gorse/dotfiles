export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

[[ -n "$TMUX" ]] && SESS_NAME=`tmux display-message -p "#S"`

	case `uname` in
	  Darwin)
	    # commands for OS X go here
	    export PYENV_ROOT="$HOME/.pyenv"
	    export PATH="$PYENV_ROOT/bin:$PATH"
	    eval "$(pyenv init -)"
	    eval "$(pyenv virtualenv-init -)"
	    export PATH="$PYENV_ROOT/shims:$PATH"
	    alias virt='foo(){ pyenv activate "$1" }; foo '
	  ;;
	  Linux)
		  # if [[ -n "$SESS_NAME" && -e "$HOME/.virtualenvs/${SESS_NAME}" ]]; then
		  # 			  export WORKON_HOME=$HOME/.virtualenvs
		  # 			  parent_find $0
		  # 			  call_file $HOME/.local/bin/virtualenvwrapper.sh $topic
		  # else
				export PYENV_ROOT="$HOME/.pyenv"
				export PATH="$PYENV_ROOT/bin:$PATH"
				eval "$(pyenv init -)"
				eval "$(pyenv init --path)"
				eval "$($PYENV_ROOT/bin/pyenv virtualenv-init -)"
				# export PATH="$PYENV_ROOT/shims:$PATH"
				alias virt='foo(){ pyenv activate "$1" }; foo '
			# fi
		# if [[ -n "$TMUX" && -n "$SESS_NAME" && -e "$HOME/.virtualenvs/${SESS_NAME}/bin/activate" ]]; then
		# 	export WORKON_HOME=$HOME/.virtualenvs
		# 	source $HOME/.local/bin/virtualenvwrapper.sh
		# 	break
		# fi
	    
		    # commands for Linux go here
		#    export WORKON_HOME=$HOME/.virtualenvs
		#    source $HOME/.local/bin/virtualenvwrapper.sh
		#    alias virt='foo(){ workon "$1" }; foo '
	  ;;
	  FreeBSD)
	    # commands for FreeBSD go here
	  ;;
	esac



