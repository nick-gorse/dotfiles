[[ -f ~/.fzf.zsh ]] && call_file ~/.fzf.zsh "fzf"
autoload -U $DOTFILES/fzf/fe
# [ -f $HOME/.dotfiles/fzf/fzf-git.sh ] && source $HOME/.dotfiles/fzf/fzf-git.sh
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always --exclude .git'
export FZF_DEFAULT_OPTS="--ansi --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,Library,.venv --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(right|hidden)'"

v() {
  local file
  file="$(fd -t f -H -E .git 2>/dev/null | fzf --preview 'bat --style=numbers --color=always --line-range :200 {}' )" || return
  ~/.local/bin/nvim-open "$file"
}


