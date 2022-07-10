case $(uname) in
Darwin)
	# commands for OS X go here
	export GOROOT=/usr/local/Cellar/go/1.17.2/libexec
	;;
Linux)
	# commands for Linux go here
	export GOROOT=$HOME/.go
	;;
FreeBSD)
	# commands for FreeBSD go here
	;;
esac
export GOPATH=$HOME/go # don't forget to change your path correctly!

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
