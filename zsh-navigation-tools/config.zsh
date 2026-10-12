alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help

autoload znt-history-widget
zle -N znt-history-widget
bindkey "^R" znt-history-widget

zle -N znt-cd-widget
bindkey "^B" znt-cd-widget
zle -N znt-kill-widget
bindkey "^Y" znt-kill-widget