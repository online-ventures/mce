# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
PS1='🐳 \[\033[1;36m\]\u@${APP_NAME-docker} \[\033[1;34m\]\w \[\033[1;36m\]# \[\033[0m\]'
umask 022

# Colorize `ls':
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll="ls -alh"
alias ll='ls $LS_OPTIONS -alh'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Vi mode
set -o vi

# Use less as default pager
export PAGER=less

# Psql
alias psql="psql -h db -U postgres johns"
