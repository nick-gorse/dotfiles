# SSH Agent should be running, once
runcount=$(ps -ef | grep "ssh-agent" | grep -v "grep" | wc -l)
if [ $runcount -eq 0 ]; then
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_ed25519
fi
