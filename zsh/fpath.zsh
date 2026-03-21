
typeset -gU fpath

[[ -d /usr/share/zsh/5.9/functions ]] && fpath+=(/usr/share/zsh/5.9/functions)
[[ -d /usr/share/zsh/functions ]] && fpath+=(/usr/share/zsh/functions)
# fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fpath=($DOTFILES/completions $fpath)

# Define excluded directory names (just names, not full paths)
EXCLUDES=(zsh scripts bash vim zplug 00-homebrew iterm2 prettifer)

# Get all directories under DOTFILES
dirs=(${DOTFILES}/*(/N))

# Loop through each exclusion and remove matches
for ex in $EXCLUDES; do
  dirs=(${dirs:#${DOTFILES}/$ex})
done

for topic_folder in $dirs; do
	if [ -d $topic_folder ]; then
		fpath=($topic_folder $fpath)
	fi
done

autoload -U $DOTFILES/bin/*(:t)

export MANPATH="$HOME/.dotfiles/man:$MANPATH"
