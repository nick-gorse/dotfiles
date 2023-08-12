# SSH Agent should be running, once
if [[ -e $HOME/.1password/agent.sock ]]; then 
    export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
else;
    runcount=$(ps -ef | grep "ssh-agent" | grep -v "grep" | wc -l)
    if [ $runcount -ne 0 ]; then
        killall -9 ssh-agent
    fi
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_ed25519
fi
