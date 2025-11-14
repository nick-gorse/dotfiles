
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
call_file $HOME/powerlevel10k/powerlevel10k.zsh-theme "theme"

function toggle-right-prompt() { p10k display '*/right'=hide,show; }
zle -N toggle-right-prompt
bindkey '^K' toggle-right-prompt

# function hide-right-pyenv() { p10k display '1/right/pyenv'=hide; }
# function show-right-pyenv() { p10k display '1/right/pyenv'=show; }