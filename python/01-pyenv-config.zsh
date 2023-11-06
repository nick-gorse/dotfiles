export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &> /dev/null; then 
	eval "$(pyenv init -)"
	eval "$(pyenv init --path)"
	if command -v pyenv-virtualenv-init &> /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
fi
