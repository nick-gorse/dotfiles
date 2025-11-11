# ===============================================================
# completion.zsh — Unified Completion System Loader
# ===============================================================
_zcompdump="${ZSH_COMPDUMP_PATH:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump}"
autoload -Uz compinit

# Only run once per week (cache)
if [[ ! -f $_zcompdump || $(find "$_zcompdump" -mtime +7 2>/dev/null) ]]; then
  compinit -i -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi

# # Optional: call diagnostics if requested
# if [[ $ZSH_COMPLETION_DEBUG == "1" ]]; then
#   source "$DOTFILES/zsh/compinit_doctor.zsh"
# fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${_zcompdump}.cache"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'