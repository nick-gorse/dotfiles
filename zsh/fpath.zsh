#fpath+=
typeset -gU fpath
typeset -U function_files
#add each topic folder to fpath so that they can add functions and completion scripts
# bin_files=($ZSH/bin)
# for topic_folder in $bin_files; do
#     if [ -d $topic_folder ]; then
#         fpath=($topic_folder $fpath)
#         typeset -gU fpath
#     fi
# done
for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

# functions_files=($ZSH/bin/*(:t))
# for func in $functions_files; do
#     if typeset -f $func >/dev/null; then
#         unset -f $func
#     fi
# done
#
autoload -U $ZSH/bin/*(:t)


