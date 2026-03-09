typeset -g DCS_ROOT=$HOME/.dcs
local _docker_context=$(docker context show)
local _envfile=${DCS_ROOT:-$HOME/.dcs}/${_docker_context}/env.system
for line in "${(@)${(@f)$(<${_envfile})}:%\#*}"; do; eval "export ${(q)line}"; done

