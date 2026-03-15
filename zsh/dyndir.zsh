# ------------------------------------------------------------
# Dynamic named directories with cached prefix mapping
# ------------------------------------------------------------

# prefix -> base directory
typeset -gA ZND_PREFIX_BASE=(
  'zsh-' "${DOTDIR:-$HOME/.dotfiles}"
  'con-' "$HOME/.config"
  'dcs-' "${DCS_CONTEXT_ROOT:-}/compose"
  'dev-' "$HOME/dev"
  'pan-' "$HOME/PAN_macbook"
)

# cache: full dynamic name -> absolute path
# example: dcs-whoami => /some/root/compose/whoami
typeset -gA ZND_NAME_PATH=()

# cache of just the prefixes, in a stable order
typeset -ga ZND_PREFIXES=(
  zsh-
  con-
  dcs-
  dev-
  pan-
)

# cache state
typeset -gi ZND_CACHE_READY=0

_znd_rebuild_cache() {
  emulate -L zsh
  setopt extendedglob nullglob

  local prefix base dir name

  ZND_NAME_PATH=()

  for prefix in "${ZND_PREFIXES[@]}"; do
    base="${ZND_PREFIX_BASE[$prefix]}"

    [[ -n "$base" && -d "$base" ]] || continue

    # allow the bare prefix itself, e.g. ~dcs-
    ZND_NAME_PATH[$prefix]="$base"

    # each direct child dir becomes a named dir
    for dir in "$base"/*(/N); do
      name="${prefix}${dir:t}"
      ZND_NAME_PATH[$name]="$dir"
    done
  done

  ZND_CACHE_READY=1
}

_znd_ensure_cache() {
  (( ZND_CACHE_READY )) || _znd_rebuild_cache
}

# manual refresh helper
znd-refresh() {
  _znd_rebuild_cache
}

# ------------------------------------------------------------
# Main dynamic named directory hook
#   $1 = mode
#     n -> resolve name to path
#     c -> completion candidates
# ------------------------------------------------------------
zsh_directory_name() {
  emulate -L zsh
  setopt extendedglob nullglob

  local mode="$1"
  local arg="$2"

  _znd_ensure_cache

  case "$mode" in
    (n)
      # Resolve:
      #   ~dcs-whoami
      #   ~dcs-whoami/data
      #   ~dcs-/foo
      local head tail resolved

      head="${arg%%/*}"
      if [[ "$arg" == */* ]]; then
        tail="${arg#"$head"/}"
      else
        tail=""
      fi

      resolved="${ZND_NAME_PATH[$head]}"
      [[ -n "$resolved" ]] || return 1

      if [[ -n "$tail" ]]; then
        reply=("$resolved/$tail")
      else
        reply=("$resolved")
      fi
      return 0
      ;;

    (c)
      # Complete:
      #   ~<TAB>          -> prefixes
      #   ~dc<TAB>        -> matching prefixes
      #   ~dcs-<TAB>      -> direct children under mapped base
      #   ~dcs-whoami/<TAB> -> nested path entries under resolved dir

      local head tail prefix base resolved
      local -a out

      # no slash yet: complete either prefixes or first-level mapped names
      if [[ "$arg" != */* ]]; then
        # first 4 chars or fewer: offer trigger prefixes
        if [[ -z "$arg" || ${#arg} -lt 4 ]]; then
          out=()
          for prefix in "${ZND_PREFIXES[@]}"; do
            [[ "$prefix" == "$arg"* ]] && out+=("$prefix")
          done
          reply=("${out[@]}")
          (( ${#reply[@]} )) && return 0
          return 1
        fi

        # if it matches a known prefix, complete the immediate child dirs
        for prefix in "${ZND_PREFIXES[@]}"; do
          [[ "$arg" == ${prefix}* ]] || continue
          base="${ZND_PREFIX_BASE[$prefix]}"
          [[ -d "$base" ]] || return 1

          local partial="${arg#$prefix}"
          out=()

          for resolved in "$base"/${~partial}*(/N); do
            out+=("${prefix}${resolved:t}")
          done

          reply=("${out[@]}")
          (( ${#reply[@]} )) && return 0
          return 1
        done

        return 1
      fi

      # slash present: resolve head, then complete inside it
      head="${arg%%/*}"
      tail="${arg#"$head"/}"

      resolved="${ZND_NAME_PATH[$head]}"
      [[ -n "$resolved" && -d "$resolved" ]] || return 1

      local parent fragment full_parent item
      if [[ "$tail" == */* ]]; then
        parent="${tail:h}"
        fragment="${tail:t}"
        full_parent="$resolved/$parent"
      else
        parent=""
        fragment="$tail"
        full_parent="$resolved"
      fi

      [[ -d "$full_parent" ]] || return 1

      out=()
      for item in "$full_parent"/${~fragment}*(N); do
        if [[ -n "$parent" ]]; then
          out+=("${head}/${parent}/${item:t}")
        else
          out+=("${head}/${item:t}")
        fi
      done

      reply=("${out[@]}")
      (( ${#reply[@]} )) && return 0
      return 1
      ;;

    (*)
      return 1
      ;;
  esac
}

# optional: refresh cache every prompt so newly created dirs appear
autoload -Uz add-zsh-hook
add-zsh-hook precmd _znd_rebuild_cache