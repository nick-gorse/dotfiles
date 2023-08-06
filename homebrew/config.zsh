declare -A foo
case $(uname) in
Darwin)
    # commands for Mac go here
    foo[x86_64]='/usr/local'
    foo[arm64]='/opt/homebrew'
    ;;
Linux)
    # commands for Linux go here
    foo[x86_64]='/home/linuxbrew/.linuxbrew'
    ;;
FreeBSD)
    # commands for FreeBSD go here
    ;;
esac
if [[ -e ${foo[$CPUTYPE]}/bin/brew ]]; then
    echo "$(${foo[$CPUTYPE]}/bin/brew shellenv)" >>$outfile
    eval "$(${foo[$CPUTYPE]}/bin/brew shellenv)"
fi