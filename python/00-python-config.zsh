export PYTHONDONTWRITEBYTECODE=1
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

[[ -n $TMUX ]] && SESS_NAME=$(tmux display-message -p "#S")

# export PYENV_ROOT="$HOME/.pyenv"
# eval "$(pyenv init -)"

# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
# eval "$(pyenv init --path)"

# declare -a LD_F CPP_F
# brew_libs=(xz readline zlib bzip2 openssl@1.1 tcl-tk)
# LD_PREFIX="-L" LD_SUFFIX="/lib" CPP_PREFIX="-I" CPP_SUFFIX="/include" 
# for library in ${(@)brew_libs}; do
# 	if [[ -d $(brew --prefix "${library}") ]]; then
# 		LD_F+=`echo ${LD_PREFIX}$(brew --prefix "${library}")${LD_SUFFIX}`
# 		CPP_F+=`echo ${CPP_PREFIX}$(brew --prefix "${library}")${CPP_SUFFIX}`
# 	fi
# done
# unset LD_PREFIX LD_SUFFIX CPP_PREFIX CPP_SUFFIX
# [[ -d $(xcrun --show-sdk-path) ]] && CPP_F+="-I$(xcrun --show-sdk-path)/usr/include"
# export LDFLAGS="${LDFLAGS}${LDFLAGS:+[:space:]}${LD_F}"
# export CPPFLAGS="${CPP_FLAGS}${CPP_FLAGS:+[:space:]}${CPP_F}"
# unset CPP_F LD_F
# export POETRY_HOME="$HOME/.poetry"
# LD_PREFIX="-L" LD_SUFFIX="/lib" LD_F=${(j. .)${(@)${(pf@)$(brew --prefix "${brew_libs[@]}")}/#/$LD_PREFIX}/%/$LD_SUFFIX}
# CPP_PREFIX="-I" CPP_SUFFIX="/include" CPP_F=${(j. .)${(@)${(pf@)$(brew --prefix "${brew_libs[@]}")}/#/$CPP_PREFIX}/%/$CPP_SUFFIX}
# CPPFLAGS="${CPP_FLAGS} ${CPP_F} -I$(xcrun --show-sdk-path)/usr/include"

# LD_PREFIX="-L" LD_SUFFIX="/lib" LDFLAGS=${${${test_b[@]}/#/$LD_PREFIX}/%/$LD_SUFFIX}
#="-L$(brew --prefix xz)/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
# export PATH="$PYENV_ROOT/shims:$PATH"
# alias virt='foo(){ pyenv activate "$1" }; foo '

# export LDFLAGS="-L$(brew --prefix xz)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"
# export CPPFLAGS="-I$(brew --prefix xz)/include  -I$(brew --prefix readline)/include -I$(brew --prefix zlib)/include -I$(xcrun --show-sdk-path)/usr/include"

