
if (( $+commands[kubectl] )); then
  eval $(kubectl cnpg completion zsh)
  compdef k=kubectl
fi

if (( $+commands[kustomize] )); then
    eval $(kustomize completion zsh)
fi
