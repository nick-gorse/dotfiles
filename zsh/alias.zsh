# mask built-ins with better defaults
alias ping='ping -c 5'
alias vi=nvim
alias grep="${aliases[grep]:-grep} --exclude-dir={.git,.vscode}"
if command -v kitten >/dev/null 2>&1; then
	alias ssh='foa(){ kitten ssh "$1" }; foa '
fi

# more ways to ls
if command -v colorls >/dev/null 2>&1; then
	alias ls='colorls -A --sd' 
	alias ll='colorls -lA --sd'
	alias la='colorls -lAh --sd'
fi
alias lsa="ls -aG --sd"
alias ldot='ls -ld .* --sd'

# disk usage
alias df='df -H'
# alias du='du -ch'
# alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# misc
alias please='sudo $(fc -ln -1)'	
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'
alias cls="clear && printf '\e[3J'"

# print things
alias print-fpath='echo -e ${FPATH//:/\\n}'
alias print-path='echo -e ${PATH//:/\\n}'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

alias dot='cd $HOME/.dotfiles/'
alias dotz='cd $HOME/.dotfiles/zsh'
if command -v subl >/dev/null 2>&1; then
	alias szrc='subl $HOME/.dotfiles/zsh/zshrc.symlink'
fi
alias vzrc='vim $HOME/.dotfiles/zsh/zshrc.symlink'
alias rl!='exec zsh'
alias s_alias='subl $DOTFILES/zsh/alias.zsh'
alias packages='subl $DOTFILES/antidote/zsh_plugins.txt'
alias mkcd='foo(){ mkdir -p "$1"; cd "$1" }; foo '
alias touchs='foa(){ touch "$1"; '${EDITOR:-vim}' "$1" }; foa '
# alias touchs='foa(){ touch "$1"; subl "$1" }; foa '
alias sub='subl -w'
alias e='$EDITOR'
alias lsub='$EDITOR $_'
alias vl='less $_'
alias cv='cat $_'
alias jc='vim $HOME/.virtualenvs/jupyter/etc/jupyter/jupyter_lab_config.py'
alias icloud='cd $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/'
alias ppip='noglob python -m pip'
alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
# alias pwhich='pyenv which $_'
alias wget='wget -c'
alias mkdir='mkdir -p'
alias mount='mount |column -t'
alias -g ±=~
alias sess='${EDITOR} $HOME/.config/kitty/sessions/${DCS_PROJ_NAME:?error}.session'
# alias zup='zplug update && zplug load --compile'
# alias zinstall='zplug install && zplug load --compile'
# alias -s {zsh,symlink}=subl
