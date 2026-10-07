# SSH Agent should be running, once
_ssh_restart() {
    killall -q -9 ssh_agent 2>/dev/null
    rm -f $HOME/.local/state/ssh/zsh.sock 2>/dev/null
    eval $(ssh-agent -a $HOME/.local/state/ssh/zsh.sock | grep -v echo | tee $HOME/.ssh/agent.env) > /dev/null 2>&1
    ssh-add $HOME/.ssh/id_script &> /dev/null
}


() {
    emulate -L zsh
    [[ -n $DEBUG_ZSH ]] && {
        export PS4='+%N:%i> '
        set -x
    }

    if [[ -z $SSH_CONNECTION ]]; then
        # eval ${(j:;:)${(M)${$(<$HOME/.ssh/agent.env)//;/}:#*=*}}
        eval $(<$HOME/.ssh/agent.env)
        kill -0 $SSH_AGENT_PID 2>/dev/null
        if ( [[ $? -eq 1 ]] || [[ ! -S $SSH_AUTH_SOCK ]] ); then
            _ssh_restart
        fi
        local runcount=( $(pgrep ssh-agent | grep -v $SSH_AGENT_PID) )
        if [[ ${#runcount} -gt 0 ]]; then
            kill -9 ${runcount:#$SSH_AGENT_PID} 2>/dev/null
        fi
        # if ( [ -S $HOME/.local/state/ssh/zsh.sock ] && ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        #     eval ${(j:;:)${(M)${$(<$HOME/.ssh/agent.env)//;/}:#*=*}}
        #     if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        #         __ssh_restart
        #     fi
        #     local runcount=( $(pgrep ssh-agent | grep -v $SSH_AGENT_PID) )
        #     if [[ ${#runcount} -gt 0 ]]; then
        #         kill -9 ${runcount:#$SSH_AGENT_PID} 2>/dev/null
        #     fi
        # else
        #     _ssh_restart
        #     # killall -q -9 ssh_agent 2>/dev/null
        #     # rm -f $HOME/.local/state/ssh/zsh.sock 2>/dev/null
        #     # eval $(ssh-agent -a $HOME/.local/state/ssh/zsh.sock | tee $HOME/.ssh/agent.env) > /dev/null 2>&1
        #     # ssh-add $HOME/.ssh/id_script &> /dev/null
        #     #local runcount=$(ps -ef | grep "ssh-agent" | grep -v "grep" | wc -l)
        #     #if [ $runcount -ne 0 ]; then
        #     #    killall -9 ssh-agent
        #     #fi
        #     #eval $(ssh-agent -s) &> /dev/null
        #     #ssh-add $HOME/.ssh/id_script &> /dev/null
        #     #ln -s $SSH_AUTH_SOCK ~/.local/state/ssh/zsh.sock
        #     #export SSH_AUTH_SOCK=${HOME}/.local/state/ssh/zsh.sock
        # fi
    fi
}
