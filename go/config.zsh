case $(uname) in
Darwin)
	# commands for OS X go here
	export GOROOT=$(brew --prefix go)
	# export GOPATH=$(brew --prefix go) # don't forget to change your path correctly!
	;;
Linux)
	# commands for Linux go here
	export GOROOT=$HOME/.go
	;;
FreeBSD)
	# commands for FreeBSD go here
	;;
esac
if [[ ! -d $HOME/go ]]; then
	mkdir -p $HOME/go/{bin,src,pkg}
fi
export GOPATH=$HOME/go

export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
