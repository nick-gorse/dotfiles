[[ -f ~/.fzf.zsh ]] && call_file ~/.fzf.zsh "fzf"
# [ -f $HOME/.dotfiles/fzf/fzf-git.sh ] && source $HOME/.dotfiles/fzf/fzf-git.sh
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always --exclude .git'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
