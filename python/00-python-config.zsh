export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

[[ -n $TMUX ]] && SESS_NAME=$(tmux display-message -p "#S")