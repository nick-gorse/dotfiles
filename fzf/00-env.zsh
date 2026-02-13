if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX=$(brew --prefix fzf)
elif [[ -x $HOME/.fzf/bin/fzf ]]; then
  FZF_PREFIX=$$HOME/.fzf
  PATH="${PATH:+${PATH}:}${(F)FZF_PREFIX}/bin"
fi
if [[ -n "${FZF_PREFIX}" ]]; then
    export FZF_PREFIX
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always --exclude .git'
    export FZF_DEFAULT_OPTS="--ansi --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,Library,.venv --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(right|hidden)'"
fi


