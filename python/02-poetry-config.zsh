if [[ ! -d $HOME/.poetry ]]; then
	curl -sSL https://install.python-poetry.org| python3 -	&> /dev/null
fi
export POETRY_HOME="$HOME/.poetry"
export PATH=$POETRY_HOME/bin:$PATH
# export ZSH_POETRY_AUTO_ACTIVATE=true
# export ZSH_POETRY_AUTO_DEACTIVATE=true
export MISE_POETRY_AUTO_INSTALL=1
export MISE_POETRY_VENV_AUTO=1
