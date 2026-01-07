typeset -g DCS_ROOT=$HOME/.dcs
local _docker_context=$(docker context show)
call_file ${DCS_ROOT:-$HOME/.dcs}/${_docker_context}/env.system "dcsctl"

