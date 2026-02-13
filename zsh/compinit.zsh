#!/usr/bin/env zsh
# ==================================================================
# compinit.zsh — cache-aware completion init
# - Fast path: compinit -C -d <dump> (skip rescans)
# - Stale path: source *completion*.zsh (+ local rc), then compinit -i
# ==================================================================



# ensure these options before compinit
setopt complete_aliases nobgnice

# dump location + TTL
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zcomp/zcompdump"
local _zcd="${ZSH_COMPDUMP:-$HOME/.cache/zcomp/zcompdump}"

# Guard if file missing
[[ ! -r "$ZSH_COMPDUMP" ]] && {
  print -u2 "comp_init: missing or unreadable: $ZSH_COMPDUMP"
  return 1
}
typeset -g -r ZSH_COMPDUMP
local ZCOMP_TTL_HOURS="${ZCOMP_TTL_HOURS:-20}"

# collect completion files from the already-built `config_files` list
typeset -a _completion_files
_completion_files=(${(M)${(@)config_files}:#*/*completion*.zsh})

# fallback if compinit.zsh is called standalone (no `config_files` in scope)
(( ${#_completion_files} == 0 )) && _completion_files=($DOTFILES/**/*completion*.zsh(N))

# include local additions if present
local _have_local_comp=0
[[ -e "$HOME/.local_comp_rc" ]] && _have_local_comp=1

# fast if either dump or compiled dump fresher than TTL hours
local _fast=0
if [[ ${_zcd}(#qNmh-${ZCOMP_TTL_HOURS}) || ${_zcd}.zwc(#qNmh-${ZCOMP_TTL_HOURS}) ]]; then
  _fast=1
fi

autoload -U compinit

if (( _fast )); then
  compinit -C -d "$_zcd"
else
  (( _have_local_comp )) && source "$HOME/.local_comp_rc"
  local f
  for f in "${_completion_files[@]}"; do
    source "$f"
  done
  compinit -i -d "$_zcd"
  { zcompile "$_zcd" 2>/dev/null } &!
fi

unset _zcd _completion_files _fast _have_local_comp ZCOMP_TTL_HOURS

_comp_options+=(globdots) # With hidden files

# +---------+
# | Options |
# +---------+

# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
# setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path  ${ZSH_COMPDUMP:h}
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Use cache for commands which use it
# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification


zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
