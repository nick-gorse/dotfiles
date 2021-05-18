export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
case `uname` in
  Darwin)
    # commands for OS X go here
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  ;;
  Linux)
    # commands for Linux go here
    export WORKON_HOME=~/.virtualenvs
    source $HOME/.local/bin/virtualenvwrapper.sh
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac


