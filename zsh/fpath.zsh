#fpath+=
typeset -gU fpath
typeset -U function_files
#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($ZSH/bin) 
    if [ -d $topic_folder ]; then  
        fpath=($topic_folder $fpath)
        typeset -gU fpath
        echo "fpath=($topic_folder $fpath)" >> $outfile;
    fi;

functions_files=($ZSH/bin/*(:t))
for func in $functions_files
    if typeset -f $func > /dev/null; then
        unset -f $func;
    fi;    

autoload -U $ZSH/bin/*(:t)
