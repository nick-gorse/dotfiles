# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview
This is a modular Zsh dotfiles repository with an automated configuration loader, symlink-based installation, and performance profiling capabilities. The system uses a `.symlink` naming convention to automatically link configuration files to `$HOME` (e.g., `zsh/zshrc.symlink` → `~/.zshrc`).

## Installation & Bootstrap

### Initial Setup
```bash
# Bootstrap dotfiles (creates symlinks for all *.symlink files)
./scripts/bootstrap

# Run all install.sh scripts across subdirectories
./scripts/install

# Install Homebrew packages (on macOS)
brew bundle --file=00-homebrew/Brewfile
```

### Symlink Convention
Files with `.symlink` extension are automatically linked to `$HOME` with a dot prefix:
- `git/gitconfig.symlink` → `~/.gitconfig`
- `zsh/zshrc.symlink` → `~/.zshrc`
- `tmux/tmux.symlink` → `~/.tmux`

## Configuration Loading System

### Load Order
The `zshrc.symlink` loads configurations in this order:
1. **PATH phase**: All `path.zsh` files
2. **CONFIG phase**: All `*.zsh` files except `path.zsh`, completion files, and `compinit.zsh`
3. **COMPLETION phase**: `zsh/compinit.zsh` (cache-aware)

### Module Structure
Each subdirectory can contain:
- `config.zsh` - Main configuration (auto-labeled by directory name)
- `*.zsh` - Additional config files (labeled by filename stem)
- `*.symlink` - Files to symlink to `$HOME`
- `install.sh` - Optional installation script

### Performance Monitoring
All config loads are timed and logged to `~/zshrc-log.json` via the `call_file` function:

```bash
# Analyze shell startup performance
dotfiles_doctor

# Show detailed timeline with microsecond precision
dotfiles_doctor --timeline

# Enable profiling for a single session
zprofrc
```

**Key metrics**:
- `SLOW_THRESHOLD=200ms` - warnings for slow loads
- `WARN_THRESHOLD=500ms` - critical performance issues
- JSON log includes: file path, label, start/end timestamps, duration, exit code

## Development Workflow

### Testing Configuration Changes
```bash
# Reload shell configuration
rl!  # or: exec zsh

# Profile startup (runs 10 times)
zbench

# Edit zshrc
vzrc  # vim
szrc  # Sublime Text

# Edit aliases
s_alias

# Navigate to dotfiles
dot    # cd ~/.dotfiles
dotz   # cd ~/.dotfiles/zsh
```

### Adding New Modules
1. Create directory: `mkdir new-module`
2. Add `config.zsh` or specific `*.zsh` files
3. Optional: Add `install.sh` for setup tasks
4. Files are auto-discovered and loaded via glob pattern in `zshrc.symlink`

### Debugging
Set `CALL_FILE_DEBUG=1` to see real-time loading output:
```bash
CALL_FILE_DEBUG=1 zsh
```

Enable per-phase logging for Homebrew setup:
```bash
HB_TRACE=1 zsh
```

## Key Components

### Homebrew (`00-homebrew/`)
- `Brewfile` - Declarative package list
- `config.zsh` - Cached LDFLAGS/CPPFLAGS computation (avoids slow `brew --prefix` calls on every shell start)
- Cache location: `~/.cache/zsh/homebrew_flags_$(uname -m).zsh`

### Antidote Plugin Manager (`antidote/`)
- `zsh_plugins.txt` - Plugin manifest
- Manages Oh-My-Zsh plugins, zsh-users utilities, and custom plugins

### Git (`git/`)
- `gitconfig.symlink` - Main git config
- `gitconfig.local.symlink.example` - Template for local overrides
- Automatically configured during bootstrap with user credentials

### Python (`python/`)
- Poetry auto-installation on first load
- Mise integration with `MISE_POETRY_AUTO_INSTALL=1` and `MISE_POETRY_VENV_AUTO=1`

### SSH (`ssh/`)
- `config` - SSH host configuration
- `*.host` - Individual host snippets
- `ssh-agent.zsh` - Agent management
- `comp.sh` - SSH completion helpers

### Vim (`vim/`)
- `vimrc` - Main configuration
- `install.sh` - Plugin setup
- `colors/` and `pack/` - Themes and packages

### Custom Scripts (`bin/`)
Notable utilities:
- `call_file` - Timed JSON logger for config loading
- `dotfiles_doctor` - Shell startup performance analyzer
- `add_ipykernal.sh` - Jupyter kernel helper
- `extract` - Universal archive extractor

## Architecture Notes

### Performance Optimization
- **Completion caching**: `compinit` uses `~/.cache/zcompdump` with 20-hour TTL
- **Homebrew caching**: Flags are cached per CPU architecture to avoid repeated `brew --prefix` calls
- **Lazy loading**: Completion files sourced only when cache is stale
- **Compiled cache**: `.zwc` files auto-compiled in background

### Modularity
The system uses glob patterns (`$DOTFILES/**/*.zsh`) to auto-discover configuration files, enabling:
- Drop-in module addition without editing central config
- Per-module isolation
- Conditional loading based on filename patterns

### Profiling Infrastructure
The `call_file` function wraps every config load with:
- Microsecond-precision timestamps (`EPOCHREALTIME`)
- Exit code tracking
- NDJSON structured logging
- Automatic label derivation from paths

This enables `dotfiles_doctor` to provide aggregate metrics, identify bottlenecks, and display load timelines.

## Environment Variables

Key variables set in `zshenv.symlink`:
- `DOTFILES="$HOME/.dotfiles"`
- `ZSH_CACHE_DIR="$HOME/.cache"`
- `outfile="$HOME/zshrc-log.json"` (logging target)

## Aliases

Common shortcuts (see `zsh/alias.zsh`):
- `dot` - cd to dotfiles
- `rl!` - reload shell
- `please` - sudo
- `ppip` - `python -m pip` with noglob
- Directory stack: `1` through `9` for `cd -N`

## Notes for AI Agents

- The `call_file` function is the core abstraction - it wraps `source` with timing/logging
- When adding configs, prefer `config.zsh` naming for directory-level settings
- The bootstrap script uses interactive prompts for symlink conflicts (skip/overwrite/backup)
- Completion system uses cache-aware two-path strategy (fast: `-C`, stale: full rescan with `-i`)
- Homebrew config avoids repeated subprocess calls by caching computed flags to disk
