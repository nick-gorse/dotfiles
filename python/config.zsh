export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

[[ -n $TMUX ]] && SESS_NAME=$(tmux display-message -p "#S")

export PYENV_ROOT="$HOME/.pyenv"

# export PATH="$POETRY_HOME/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

eval "$(pyenv virtualenv-init -)"

export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
export POETRY_HOME="$HOME/.poetry"
# export PATH="$PYENV_ROOT/shims:$PATH"
# alias virt='foo(){ pyenv activate "$1" }; foo '
