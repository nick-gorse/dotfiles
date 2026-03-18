# SSH Agent should be running, once
() {
    emulate -L zsh
    [[ -n $DEBUG_ZSH ]] && {
        export PS4='+%N:%i> '
        set -x
    }

    if [[ -z $SSH_CONNECTION ]]; then
        if [ -S $HOME/.local/state/ssh/zsh.sock ]; then
            eval ${(j:;:)${(M)${$(<$HOME/.ssh/agent.env)//;/}:#*=*}}
            local runcount=( $(pgrep ssh-agent) )
            [ ${#runcount} -gt 1 ] || kill -9 ${runcount:#$SSH_AGENT_PID} 2>/dev/null
        else
            killall -q -9 ssh_agent 2>/dev/null
            rm -f $HOME/.local/state/ssh/zsh.sock 2>/dev/null
            eval $(ssh-agent -a $HOME/.local/state/ssh/zsh.sock | tee $HOME/.ssh/agent.env) > /dev/null 2>&1
            ssh-add $HOME/.ssh/id_script &> /dev/null
            #local runcount=$(ps -ef | grep "ssh-agent" | grep -v "grep" | wc -l)
            #if [ $runcount -ne 0 ]; then
            #    killall -9 ssh-agent
            #fi
            #eval $(ssh-agent -s) &> /dev/null
            #ssh-add $HOME/.ssh/id_script &> /dev/null
            #ln -s $SSH_AUTH_SOCK ~/.local/state/ssh/zsh.sock
            #export SSH_AUTH_SOCK=${HOME}/.local/state/ssh/zsh.sock
        fi
    fi
}
