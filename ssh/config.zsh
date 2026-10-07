
_ssh-agent-check() {
    source $DOTFILES/ssh/ssh-agent.zsh
}

if [[ -n $functions[_ssh-agent-check] ]] ; then
   autoload -Uz add-zsh-hook
   add-zsh-hook precmd _ssh-agent-check
fi