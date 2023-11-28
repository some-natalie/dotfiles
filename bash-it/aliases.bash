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
alias exif-strip='exiftool -all= *.jpg'
alias free='free -h'
alias hg='history | grep'
alias k='kubectl'
alias kgc='kubectl config get-contexts'
alias ksc='kubectl config use-context'
alias ls='ls -lhaF'
alias mkdir='mkdir -p'
alias myip='curl http://ipecho.net/plain; echo'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias okta="security find-generic-password -l device_trust '-w'"
alias pip3-update="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install -U"
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias pwgen='openssl rand -base64 12'
alias sshgen='ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date -I)"'
alias wget='wget -c'
alias youtube='youtube-dl --newline'
alias zz='sudo !!'

# Aliases for GitHub Copilot CLI
alias 'gh?'='gh copilot explain'
alias 'ghc'='gh copilot suggest'
