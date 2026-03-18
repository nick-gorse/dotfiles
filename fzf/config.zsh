if [[ -d "${FZF_PREFIX}" ]]; then
    autoload -Uz $DOTFILES/fzf/fe
    # [ -f $HOME/.dotfiles/fzf/fzf-git.sh ] && source $HOME/.dotfiles/fzf/fzf-git.sh
    v() {
      local file
      file="$(fd -t f -H -E .git 2>/dev/null | fzf --preview 'bat --style=numbers --color=always --line-range :200 {}' )" || return
      nvim --server "$NVIM_SERVER" --remote "$file"
    }
    call_file "${FZF_PREFIX}/shell/key-bindings.zsh" "fzf"
fi


if ! command -v fd >/dev/null 2>&1; then
    command -v fdfind >/dev/null 2>&1 && ln -s $(which fdfind) $HOME/.local/bin/fd
fi
