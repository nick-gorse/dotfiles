typeset -gU fpath

fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

# Define excluded directory names (just names, not full paths)
EXCLUDES=(zsh scripts bash ssh vim zplug 00-homebrew iterm2 prettifer)

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


