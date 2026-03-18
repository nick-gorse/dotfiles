# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${DOTFILES}/antidote/zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($HOME/.antidote/functions $fpath)
autoload -Uz antidote

ZSH=$(antidote path ohmyzsh/ohmyzsh)
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:static' file "${DOTFILES}/antidote/zsh_plugins"
zstyle ':antidote:static' zcompile 'yes'
if [[ ! ${zsh_plugins} -nt ${zsh_plugins}.txt ]]; then
    echo "${$(antidote bundle <${zsh_plugins}.txt)//source/call_file}" >|${zsh_plugins}
    #antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.compile
fi
call_file ${zsh_plugins} "antidote_plugin"
