# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${DOTFILES}/antidote/zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($HOME/.antidote/functions $fpath)
autoload -Uz antidote

zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:bundle' file "${DOTFILES}/antidote/zsh_plugins.txt"
zstyle ':antidote:static' file "${DOTFILES}/antidote/zsh_plugins"
zstyle ':antidote:static' zcompile 'yes'
if [[ ${zsh_plugins}.txt -nt ${zsh_plugins} ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}
    if [[ ${zsh_plugins} -nt ${zsh_plugins}.zwc ]]; then
      zcompile ${zsh_plugins}
    fi
fi
ZSH=$(antidote path ohmyzsh/ohmyzsh)
call_file ${zsh_plugins} "antidote_plugin_compiled"
