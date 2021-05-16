case `uname` in
  Darwin)
    # commands for OS X go here
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  ;;
  Linux)
    # commands for Linux go here
    export PYTHONDONTWRITEBYTECODE=1  # don't write .pyc files
    export WORKON_HOME=~/.virtualenvs
    source $HOME/.local/bin/virtualenvwrapper.sh
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac


