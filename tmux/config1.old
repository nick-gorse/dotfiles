#!/usr/bin/zsh
if [ -n "$TMUX" ] && [[ -n "$LC_TMUX" && -e "$HOME/.virtualenvs/$LC_TMUX/bin/activate" ]] && [[ $- =~ i ]]; then
    source $HOME/.virtualenvs/jupyter/bin/activate
    alias deactivate=exit
    alias workon=exit
fi

if [[ "$LC_TMUX" == "jupyter" ]]; then
    JUP_PID=`cat $HOME/.jup_pid`
    if ! ps -o pid --no-headers -fp $JUP_PID > /dev/null 2>&1; then
#        source $HOME/.virtualenvs/jupyter/bin/activate >| $HOME/jup.log 2>&1
        $HOME/.virtualenvs/jupyter/bin/python $HOME/.virtualenvs/jupyter/bin/jupyter-lab
        echo $! >| $HOME/.jup_pid
        tail -f $HOME/jup.log
    fi
fi
