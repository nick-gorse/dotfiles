if [[ ${LC_TERMINAL} == 'iTerm2' ]]; then
  export NVIM_SERVER=127.0.0.1:${NVIM_PORT:-7777}

  call_file $HOME/.dotfiles/iterm2/iterm2_shell_integration
  iterm2_print_user_vars() {
      iterm2_set_user_var nvim_serv "${NVIM_SERVER}"
  }
fi
