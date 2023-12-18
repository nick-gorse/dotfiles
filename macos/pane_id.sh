#/opt/homebrew/bin/zsh
# SCRIPT_FILE_REL_PATH="${BASH_SOURCE[0]}"
# if [[ "$SCRIPT_FILE_REL_PATH" == "" ]]; then
#   SCRIPT_FILE_REL_PATH="${(%):-%N}"
# fi
# SCRIPT_FILE_PATH="`realpath $SCRIPT_FILE_REL_PATH`"
# SCRIPT_DIR="`dirname $SCRIPT_FILE_PATH`"

# echo $SCRIPT_DIR

SOURCE=${BASH_SOURCE[0]:-${(%):-%x}}
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
echo $DOTFILES_DIR