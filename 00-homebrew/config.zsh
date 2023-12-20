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
    echo "\n----- Start Environment Variables set for homebrew" >>$outfile
    echo "$(${foo[$CPUTYPE]}/bin/brew shellenv)" >>$outfile
    eval "$(${foo[$CPUTYPE]}/bin/brew shellenv)"
    echo "----- End Environment Variables set for homebrew" >>$outfile
fi
declare -a LD_F CPP_F PKG_F
brew_libs=(xz readline zlib bzip2 openssl@1.1 openssl@3 tcl-tk openblas lapack openjdk@11)
LD_PREFIX="-L" LD_SUFFIX="/lib" CPP_PREFIX="-I" CPP_SUFFIX="/include" PKG_SUFFIX="/lib/pkgconfig"
LD_F+=`echo ${LD_PREFIX}$(brew --prefix )${LD_SUFFIX}`
CPP_F+=`echo ${CPP_PREFIX}$(brew --prefix "${library}")${CPP_SUFFIX}`
echo "----- Start Adding Libraries from homebrew" >>$outfile
for library in ${(@)brew_libs}; do
    if [[ -d $(brew --prefix "${library}") ]]; then
        LD_F+=`echo ${LD_PREFIX}$(brew --prefix "${library}")${LD_SUFFIX}`
        CPP_F+=`echo ${CPP_PREFIX}$(brew --prefix "${library}")${CPP_SUFFIX}`
        [[ -d `echo $(brew --prefix "${library}")${PKG_SUFFIX}` ]] && PKG_F+=`echo $(brew --prefix "${library}")${PKG_SUFFIX}`
        echo "added library '`echo $library`' from brew into [LD, CPP and PKG]" >> $outfile
    fi
done
unset LD_PREFIX LD_SUFFIX CPP_PREFIX CPP_SUFFIX PKG_SUFFIX brew_libs
if which xcrun > /dev/null; then
    [[ -d $(xcrun --show-sdk-path) ]] && LD_F+="-L$(xcrun --show-sdk-path)/usr/lib"
    [[ -d $(xcrun --show-sdk-path) ]] && CPP_F+="-I$(xcrun --show-sdk-path)/usr/include"
fi
export LDFLAGS="${LDFLAGS}${LDFLAGS:+ }${LD_F}"
export CPPFLAGS="${CPP_FLAGS}${CPP_FLAGS:+ }${CPP_F}"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+:}${PKG_F}"
export HOMEBREW_BUNDLE_FILE="${DOTFILES}/00-homebrew/Brewfile"
echo "----- End Adding Libraries from homebrew" >>$outfile
unset CPP_F LD_F PKG_F