# ------------------------------------------------------------
# Dynamic named directories with cached prefix mapping
# Modes (per zshexpn(1)):
#   n  -> resolve dynamic name to path       (reply=(path))
#   d  -> resolve path to dynamic name       (reply=(name prefixlen))
#   c  -> completion — must call _wanted/compadd directly, return 0/1
# ------------------------------------------------------------

# Debug logging — set DYNDIR_DEBUG=1 to enable
typeset -g _ZND_LOG="$HOME/dyndir.log"
_znd_log() {
  (( ${DYNDIR_DEBUG:-0} )) || return 0
  print -r -- "[$(/bin/date '+%T.%3N')] [$$] $*" >> "$_ZND_LOG"
}
(( ${DYNDIR_DEBUG:-0} )) && : > "$_ZND_LOG"
_znd_log "zdyndir.zsh loaded — DCS_CONTEXT_ROOT=${DCS_CONTEXT_ROOT:-UNSET}"

# prefix -> base directory (populated lazily so DCS_CONTEXT_ROOT is evaluated
# at runtime, not parse time)
typeset -gA ZND_PREFIX_BASE=()

# cache: full dynamic name -> absolute path
typeset -gA ZND_NAME_PATH=()

# ordered prefix list
typeset -ga ZND_PREFIXES=(zsh- con- dcs- dev- pan-)

# cache state
typeset -gi ZND_CACHE_READY=0

_znd_rebuild_cache() {
  emulate -L zsh
  setopt extendedglob nullglob

  ZND_PREFIX_BASE=(
    'zsh-' "${DOTFILES:-$HOME/.dotfiles}"
    'con-' "$HOME/.config"
    'dcs-' "${DCS_CONTEXT_ROOT:-}/compose"
    'dev-' "$HOME/dev"
    'pan-' "$HOME/PAN_macbook"
  )

  _znd_log "rebuild_cache: DCS_CONTEXT_ROOT=${DCS_CONTEXT_ROOT:-UNSET} dcs-base=${ZND_PREFIX_BASE[dcs-]}"

  local prefix base dir name
  ZND_NAME_PATH=()

  for prefix in "${ZND_PREFIXES[@]}"; do
    base="${ZND_PREFIX_BASE[$prefix]}"
    if [[ -z "$base" || ! -d "$base" ]]; then
      _znd_log "  skip $prefix => ${base:-EMPTY} (not a dir)"
      continue
    fi
    ZND_NAME_PATH[$prefix]="$base"
    local count=0
    for dir in "$base"/*(/N); do
      ZND_NAME_PATH[${prefix}${dir:t}]="$dir"
      (( count++ ))
    done
    _znd_log "  $prefix => $base ($count children)"
  done

  ZND_CACHE_READY=1
  _znd_log "rebuild_cache: done — ${#ZND_NAME_PATH} entries"
}

_znd_ensure_cache() { (( ZND_CACHE_READY )) || _znd_rebuild_cache }
znd-refresh()        { _znd_rebuild_cache }


zsh_directory_name() {
  emulate -L zsh
  setopt extendedglob nullglob

  local mode="$1" arg="$2"
  _znd_log "zsh_directory_name: mode=$mode arg=${arg:-EMPTY}"
  _znd_ensure_cache

  case "$mode" in

    # ------------------------------------------------------------------
    # n: name -> path
    #    reply=(path), return 0; or return 1
    # ------------------------------------------------------------------
    (n)
      local head="${arg%%/*}" tail=""
      [[ "$arg" == */* ]] && tail="${arg#"$head"/}"

      local resolved="${ZND_NAME_PATH[$head]}"
      if [[ -z "$resolved" ]]; then
        _znd_log "  n: NOT FOUND head=$head"
        return 1
      fi

      reply=("${resolved}${tail:+/$tail}")
      _znd_log "  n: reply=${reply[1]}"
      return 0
      ;;

    # ------------------------------------------------------------------
    # d: path -> name
    #    reply=(dynname prefixlen), return 0; or return 1
    #    Used by prompt %~ and directory stack display.
    # ------------------------------------------------------------------
    (d)
      local dir="$arg" prefix base name path
      for prefix in "${ZND_PREFIXES[@]}"; do
        base="${ZND_PREFIX_BASE[$prefix]}"
        [[ -n "$base" && "$dir" == "$base"/* || "$dir" == "$base" ]] || continue
        # find the most specific (longest) match
        for name in ${(k)ZND_NAME_PATH}; do
          path="${ZND_NAME_PATH[$name]}"
          if [[ "$dir" == "$path"/* || "$dir" == "$path" ]]; then
            if [[ ${#path} -gt ${#${reply[2]:-}} ]]; then
              reply=("$name" "${#path}")
            fi
          fi
        done
      done
      if [[ -n "${reply[1]}" ]]; then
        _znd_log "  d: reply=${reply[1]} prefixlen=${reply[2]}"
        return 0
      fi
      _znd_log "  d: no match for $dir"
      return 1
      ;;


    # ------------------------------------------------------------------
    # c: completion
    #    Must call _wanted/compadd directly — reply is NOT used.
    #    return 0 if candidates added, 1 if none.
    #    Per zshexpn(1) example and _dynamic_directory_name source.
    # ------------------------------------------------------------------
    (c)
      local expl prefix base partial
      local -a candidates

      # Shift the bracket into the ignored prefix so compadd -S']' produces
      # ~[name] — the user types ~<TAB> or ~dcs-<TAB>, gets ~[dcs-whoami]
      # IPREFIX is already '~' (set by _main_complete compset -p 1)
      IPREFIX="${IPREFIX}["

      # PREFIX is what's typed after the ~ (e.g. "" or "dcs-" or "dcs-who")
      local typed="${PREFIX}"
      _znd_log "  c: PREFIX=${typed:-EMPTY} IPREFIX=${IPREFIX}"

      # Exact prefix match -> children of that prefix
      for prefix in "${ZND_PREFIXES[@]}"; do
        if [[ "$typed" == "$prefix" ]]; then
          base="${ZND_PREFIX_BASE[$prefix]}"
          _znd_log "  c: exact prefix=$prefix base=$base"
          [[ -d "$base" ]] || return 1
          candidates=()
          local dir
          for dir in "$base"/*(/N); do
            candidates+=("${prefix}${dir:t}")
          done
          _znd_log "  c: exact candidates=${#candidates} first=${candidates[1]:-NONE}"
          _wanted dynamic-dirs expl 'dynamic directory' \
            compadd -S ']' -a candidates
          return
        fi
      done

      # Typed starts with a known prefix but has more -> filter children
      for prefix in "${ZND_PREFIXES[@]}"; do
        if [[ "$typed" == ${prefix}* ]]; then
          base="${ZND_PREFIX_BASE[$prefix]}"
          partial="${typed#$prefix}"
          _znd_log "  c: partial prefix=$prefix partial=$partial base=$base"
          [[ -d "$base" ]] || return 1
          candidates=()
          local dir
          for dir in "$base"/${~partial}*(/N); do
            candidates+=("${prefix}${dir:t}")
          done
          _znd_log "  c: partial candidates=${#candidates} first=${candidates[1]:-NONE}"
          _wanted dynamic-dirs expl 'dynamic directory' \
            compadd -S ']' -a candidates
          return
        fi
      done

      # Partial prefix -> offer matching prefixes (no closing ] yet, name incomplete)
      candidates=()
      for prefix in "${ZND_PREFIXES[@]}"; do
        [[ "$prefix" == "$typed"* ]] && candidates+=("$prefix")
      done
      _znd_log "  c: prefix-list candidates=${#candidates}: ${candidates[@]}"
      (( ${#candidates} )) || return 1
      _wanted dynamic-dirs expl 'dynamic directory' \
        compadd -S '' -a candidates
      return
      ;;

    (*)
      _znd_log "  unknown mode=$mode"
      return 1
      ;;
  esac
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _znd_rebuild_cache
