#fpath+=
typeset -gU fpath
#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($ZSH/bin) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

autoload -U $ZSH/bin/*(:t)
