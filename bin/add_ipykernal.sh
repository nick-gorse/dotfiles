#!/bin/zsh
if [[ -n $VIRTUAL_ENV && ! -f "./$VENV_FILE_EXTENSION" ]]; then
    echo python -m ipykernel install --user --name=$(basename $VIRTUAL_ENV)
fi
