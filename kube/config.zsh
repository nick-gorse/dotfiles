#/usr/bin/env zsh
export KUSTOMIZE_ENABLE_PLUGINS=true
(( ${+commands[kubectl]} )) && zsh-defer eval $(kubectl completion zsh)