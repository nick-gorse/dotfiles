export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
case `uname` in
  Darwin)
    # commands for OS X go here
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PATH="$PYENV_ROOT/shims:$PATH"
    alias virt='foo(){ pyenv activate "$1" }; foo '
  ;;
  Linux)
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PATH="$PYENV_ROOT/shims:$PATH"
    alias virt='foo(){ pyenv activate "$1" }; foo '
    # commands for Linux go here
#    export WORKON_HOME=$HOME/.virtualenvs
#    source $HOME/.local/bin/virtualenvwrapper.sh
#    alias virt='foo(){ workon "$1" }; foo '
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac


