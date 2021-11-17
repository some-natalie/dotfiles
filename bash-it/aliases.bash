# # # # # # # # # # # # # #
# Aliases for general use #
# # # # # # # # # # # # # #

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias c='clear'
alias csrgen='openssl req -out CSR.csr -new -newkey rsa:4096 -nodes -keyout privatekey.key'
alias df='df -h -x tmpfs -x devtmpfs'
alias dft='df -Tha --total'
alias diskspace='du -S | sort -n -r | more'
alias dl='curl -OJL'
alias du='du -chd 1'
alias free='free -h'
alias hg='history | grep'
alias ls='ls -lhaF'
alias mkdir='mkdir -p'
alias myip='curl http://ipecho.net/plain; echo'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psu="ps uxU ${1}"
alias pwgen='openssl rand -base64 12'
alias sshgen='ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date -I)"'
alias wget='wget -c'
alias youtube='youtube-dl --newline'
alias zz='sudo !!'


# # # # # # # # # #
# Aliases for git #
# # # # # # # # # #

alias gitgraph="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias git-yolo='git commit -am "`curl -s http://whatthecommit.com/index.txt`"'
alias git-friday-afternoon='git commit -a -m "obviously not a read-only friday"; git push --force'
