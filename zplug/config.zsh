# --- zplug speed-optimised config ---

# Define paths
export ZPLUG_HOME=$HOME/.zplug
export ZPLUG_CACHE_DIR=$HOME/.cache/zplug
mkdir -p $ZPLUG_CACHE_DIR

# Only clone once
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone --depth=1 https://github.com/zplug/zplug $ZPLUG_HOME
fi

# Use cache
export ZPLUG_USE_CACHE=true

# Load from external package list
ZPLUG_LOADFILE=${DOTFILES}/zplug/packages



if [[ -f ${ZPLUG_CACHE_DIR}/zplug.init.zsh.zwc ]]; then
  call_file ${ZPLUG_CACHE_DIR}/zplug.init.zsh.zwc "zplug"
else
  call_file $ZPLUG_HOME/init.zsh "zplug"
  
  # If plugins missing, install them (run once, not every shell)
  if ! zplug check --verbose; then
    echo "Installing missing plugins..."
    zplug install
  fi
  zplug load
fi