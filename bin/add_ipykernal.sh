#!/bin/zsh

if [[ -n $VIRTUAL_ENV && ! -f "./$VENV_FILE_EXTENSION" ]]; then
    if [[ ! -e $(JUPYTER_PREFER_ENV_PATH=0 jupyter --data-dir)"/kernels/"$(basename "${VIRTUAL_ENV//%\/.venv/}") ]]; then
        [[ `$VIRTUAL_ENV/bin/python -m ipykernel -V &> /dev/null` ]] || $VIRTUAL_ENV/bin/python -m pip install ipykernel
        $VIRTUAL_ENV/bin/python -m ipykernel install --user --name=$(basename "${VIRTUAL_ENV//%\/.venv/}")
    fi
fi
