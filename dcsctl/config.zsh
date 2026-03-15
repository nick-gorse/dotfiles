_create_env() {
    cat <<< "# DCS context configuration
# DCS_ROOT: local base directory that contains context folders
# DCS_CONTEXT_ROOT: local root for THIS context (contains env.system + compose/)
# HOST_DATA_ROOT: bind-mount root on the Docker HOST
DCS_ROOT=${DCS_ROOT}
DCS_CONTEXT_ROOT=${1}
HOST_DATA_ROOT=/srv/docker/appdata
HOST_LOCAL_ROOT=/srv/local/appdata
DCS_TEMPLATE=${1}/_defaults" > ${1}/env.system

}

() {
    emulate -L zsh
    [[ -n $DEBUG_ZSH ]] && {
      export PS4='+%N:%i> '
      set -x
  }
local _docker_context=$(docker context show)
local _docker_context_dir=${DCS_ROOT:-$HOME/.dcs}/${_docker_context:-default}
if [[ ! -d $_docker_context_dir ]]; then
    mkdir -p ${_docker_context_dir}/{compose,_defaults}
fi
local _envfile=${_docker_context_dir}/env.system

if [[ ! -e $_envfile ]]; then
    _create_env $_docker_context_dir
fi
}

for line in "${(@)${(@f)$(<${_envfile})}:%\#*}"; do; eval "export ${(q)line}"; done
[[ -e $HOST_LOCAL_ROOT ]] && ln -s $DCS_CONTEXT_ROOT/compose $HOST_LOCAL_ROOT/compose
