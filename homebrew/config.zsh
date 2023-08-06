case $(uname) in
Darwin)
    # commands for OS X go here
    [[ -e /opt/homebrew/bin/brew && $(arch) =~ 'arm.*' ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [[ -e /usr/local/bin/brew && $(arch) =~ '.*86.*' ]] && eval "$(/usr/local/bin/brew shellenv)"
    ;;
Linux)
    # commands for Linux go here
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
FreeBSD)
    # commands for FreeBSD go here
    ;;
esac