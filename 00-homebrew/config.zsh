#!/usr/bin/env zsh
# ===============================================================
# Homebrew Environment Setup (macOS, Linux, FreeBSD)
# Modern JSON-safe version
# ===============================================================

# Detect platform and architecture
declare -A brew_prefix
case "$(uname)" in
  Darwin)
    brew_prefix[x86_64]="/usr/local"
    brew_prefix[arm64]="/opt/homebrew"
    ;;
  Linux)
    brew_prefix[x86_64]="/home/linuxbrew/.linuxbrew"
    ;;
  FreeBSD)
    brew_prefix[x86_64]="/usr/local"
    ;;
esac

# Detect current architecture (fallback for older macOS)
CPUTYPE="$(uname -m)"

# If brew exists, initialize its environment
if [[ -x "${brew_prefix[$CPUTYPE]}/bin/brew" ]]; then
  eval "$(${brew_prefix[$CPUTYPE]}/bin/brew shellenv 2>/dev/null)"
fi

# Skip if brew not available
if ! command -v brew >/dev/null 2>&1; then
  return 0
fi

# Core library paths for linkage
brew_libs=(xz readline zlib bzip2 openssl@3 tcl-tk openblas lapack openjdk@17)
LD_Flags=()
CPP_Flags=()
PKG_Paths=()

LD_PREFIX="-L"
CPP_PREFIX="-I"
LD_SUFFIX="/lib"
CPP_SUFFIX="/include"
PKG_SUFFIX="/lib/pkgconfig"

# Always include the core Homebrew prefix
LD_Flags+=("${LD_PREFIX}$(brew --prefix)${LD_SUFFIX}")
CPP_Flags+=("${CPP_PREFIX}$(brew --prefix)${CPP_SUFFIX}")

# Add optional libraries
for library in "${(@)brew_libs}"; do
  prefix="$(brew --prefix "$library" 2>/dev/null)"
  [[ -z "$prefix" || ! -d "$prefix" ]] && continue

  LD_Flags+=("${LD_PREFIX}${prefix}${LD_SUFFIX}")
  CPP_Flags+=("${CPP_PREFIX}${prefix}${CPP_SUFFIX}")
  [[ -d "${prefix}${PKG_SUFFIX}" ]] && PKG_Paths+=("${prefix}${PKG_SUFFIX}")
done

# Xcode SDK (macOS only)
if command -v xcrun >/dev/null 2>&1; then
  sdk_path="$(xcrun --show-sdk-path 2>/dev/null)"
  if [[ -d "$sdk_path" ]]; then
    LD_Flags+=("${LD_PREFIX}${sdk_path}/usr/lib")
    CPP_Flags+=("${CPP_PREFIX}${sdk_path}/usr/include")
  fi
fi

# Export environment variables (deduplicated)
typeset -U LD_Flags CPP_Flags PKG_Paths

export LDFLAGS="${LDFLAGS}${LDFLAGS:+ }${(j: :)LD_Flags}"
export CPPFLAGS="${CPPFLAGS}${CPPFLAGS:+ }${(j: :)CPP_Flags}"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}${PKG_CONFIG_PATH:+:}${(j/:/)PKG_Paths}"
export HOMEBREW_BUNDLE_FILE="${DOTFILES}/00-homebrew/Brewfile"

# Done — no stdout/stderr or file writes.
return 0
