case $(uname) in
Darwin)
    case ${${$(uname -m)%64}//_/} in
        arm)
            BREWHOME='/opt/homebrew'
            ;;
        x86)
            BREWHOME='/usr/local'
            ;;
        esac
    echo "$(${BREWHOME}/bin/brew shellenv)" >>$outfile
    [[ -e ${BREWHOME}/bin/brew ]]  && eval "$(${BREWHOME}/bin/brew shellenv)"
    # [[ -e /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
    ;;
Linux)
    # commands for Linux go here
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
FreeBSD)
    # commands for FreeBSD go here
    ;;
esac