export ZPLUG_CACHE_DIR=$HOME/.cache/zplug
export ZPLUG_USE_CACHE=true
export ZPLUG_LOADFILE=${DOTFILES}/zplug/packages
if [[ ! -d $HOME/.zplug ]]; then
    export ZPLUG_HOME=$HOME/.zplug
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source $HOME/.zplug/init.zsh
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    zplug install &> /dev/null 
    zplug update &> /dev/null
else;
    source $HOME/.zplug/init.zsh
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    if ! zplug check; then
        zplug install &> /dev/null
    fi
    zplug load &> /dev/null
fi