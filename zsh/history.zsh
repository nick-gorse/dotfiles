if [[ -x "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    call_file $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh "history substring"
else
    call_file $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh "history substring"
fi
HISTFILE=$HOME/.zsh_history
SAVEHIST=100000
HISTSIZE=100000
HISTIGNORE=ls:ll:cd:pwd:..:...:htop:reload:r:la 
setopt inc_append_history
setopt hist_ignore_all_dups
setopt histignorespace
setopt extended_history
setopt share_history
setopt hist_verify
setopt hist_reduce_blanks



zmodload zsh/terminfo
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down

# History search
# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# [[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
# [[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

setopt HIST_IGNORE_SPACE

# zsh-history-substring-search key bindings
