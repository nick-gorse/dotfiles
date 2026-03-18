if [[ ${LC_TERMINAL} == 'iTerm2' ]]; then
    function _update_iterm2_nvim_server() {
        if [[ -n "$NVIM_SERVER" ]]; then
            printf "\e]1337;SetUserVar=nvim_serv=%s\a" "$(echo -n "$NVIM_SERVER" | base64)"
        fi
    }
    # Hook it so it updates whenever NVIM_SERVER changes 124123
    typeset -g NVIM_SERVER
    function nvim() {
        command nvim "$@"
    }
    precmd_functions+=(_update_iterm2_nvim_server)
fi