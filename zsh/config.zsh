export EDITOR='vim'
export VISUAL='vim'


# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt NO_BG_NICE
source ~/powerlevel10k/powerlevel10k.zsh-theme
