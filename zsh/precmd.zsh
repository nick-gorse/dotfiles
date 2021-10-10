function saas_recall() {
	unset testy
	if [ -n "$TMUX" ]; then
		local SESS_NAME=`tmux display-message -p "#S"`
		testy="sess:${SESS_NAME} - py:${PYENV_VERSION:-${VIRTUAL_ENV##*/}}"
	else
		if [[ -n ${PYENV_VERSION-${VIRTUAL_ENV##*/}} ]]; then 
			testy="py:${PYENV_VERSION:-${VIRTUAL_ENV##*/}}" 
		else 
			testy="$PWD"
		fi
		
		# out_p=(echo
	fi
}
			#
precmd(){
	saas_recall
	# # Restore tmux-title to 'zsh'
	printf "\033k${testy}\033\\"
	# # Restore urxvt-title to 'zsh'
	print -Pn "\e]2;${testy}:%~\a"
}
preexec(){
	saas_recall
	# set tmux-title to running program
	printf "\033k$(echo "$1" | cut -d" " -f1) ${testy}\033\\"
	# set urxvt-title to running program
	print -Pn "\e]2;$(echo "$1" | cut -d" " -f1) - %~ ${testy}\a"
}