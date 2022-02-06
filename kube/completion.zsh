if [[ -e /usr/bin/minikube ]]; then 
    source <(minikube completion zsh)
    alias kubectl="minikube kubectl --"
    alias k=kubectl
fi

# if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

source <(kubectl completion zsh)
compdef __start_kubectl kubectl
