# call_file $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh "history substring"
HISTFILE=$HOME/.zsh_history
SAVEHIST=5000
HISTSIZE=5000
HISTIGNORE=ls:ll:cd:pwd:..:...:htop:reload:r
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt histignorespace
setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_reduce_blanks

# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down

# History search
# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# [[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
# [[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# setopt append_history                   # adds history
# setopt inc_append_history share_history # adds history incrementally and share it across sessions
# setopt hist_ignore_all_dups             # don't record dupes in history

setopt HIST_IGNORE_SPACE

# zsh-history-substring-search key bindings
