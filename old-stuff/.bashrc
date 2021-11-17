# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


# # # # # # # # # #
# Bash Completion #
# # # # # # # # # #

[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion


# # # # # # # #
# ANSI colors #  http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# # # # # # # #

RED="\[\033[0;31m\]"
YELLOW="\033[1;33m"
GREEN="\[\033[0;32m\]"
BLUE="\033[0;34m"
PURPLE="\[\033[0;35m\]"
LIGHT_GREY="\[\033[0;37m\]"
DARK_GREY="\[\033[1;30m\]"
NO_COLOR="\033[0m"


# # # # # # # # #
# Pretty colors #
# # # s# # # # # #

PS1="\[\033[01;35m\]\h\[\033[00m\] \[\033[01;34m\]\$(pwd | sed 's/^.//g' | sed 's/\(.\)[^\/]*\//\1\//g' | sed 's/^\(.\)/\/\1/g' | sed 's/^$/\//')\[\033[00m\] \\$ "  # user
# PS1="\[\033[01;31m\]\u\[\033[00m\]\[\033[31m\]@\[\033[01;31m\]\h\[\033[00m\] \[\033[01;34m\]\$(pwd | sed 's/^.//g' | sed 's/\(.\)[^\/]*\//\1\//g' | sed 's/^\(.\)/\/\1/g' | sed 's/^$/\//')\[\033[00m\] \\$ "  # root


# # # # # #
# Exports #
# # # # # #

export PATH=$PATH:~/.packer
export EDITOR=/usr/bin/nano
export PAGER=/usr/bin/less
export HISTIGNORE="history;ls;w;date;man *;exit"
export HISTTIMEFORMAT="%d-%b-%y %H:%M   "
export HISTCONTROL="ignoreboth"


# # # # # # # # # # # # #
# Aliases to VirtualBox #
# # # # # # # # # # # # #

alias vbsetup='/etc/init.d/vboxdrv setup'  # Recompile vbox kernel module for dkms


# # # # # # # # # # #
# Aliases to Packer #  (JSONs build on VirtualBox)
# # # # # # # # # # #

#alias packer='packerio'
alias p-centos7cis='packer build centos7-cis.json'
alias p-centos7='packer build centos7-minimal.json'
alias p-centos6='packer build centos6-minimal.json'
alias p-ubuntu1404='packer build ubuntu1404-minimal.json'
alias p-ubuntu1504='packer build ubuntu1504-minimal.json'
alias p-fedora22='packer build fedora22.json'


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
alias nano='nano -q'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias pip2-update='pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install -U'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psu="ps uxU ${1}"
alias pwgen='openssl rand -base64 12'
alias sshgen='ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date -I)"'
alias wget='wget -c'
alias youtube='youtube-dl --newline'
alias zz='sudo !!'


# # # # # # # # # # # # #
# Aliases for SaltStack #
# # # # # # # # # # # # #

# Highstate stuff
alias highstate="salt -b 5 '*' state.highstate --state-output=terse"
alias highstate-test="salt -b 5 '*' state.highstate --state-output=terse test=True"
alias highstate-json="salt -b 5 '*' state.highstate --output=json --out-indent=2 --output-file=$(date +"%m_%d_%Y")-highstate.json"

# General stuff
alias salt-ip="salt '*' network.ip_addrs"
alias salt-ping="salt '*' test.ping --state-output=terse"
alias salt-rhn="salt -G 'osfinger:Red Hat Enterprise Linux Server-7' cmd.shell 'rhn-profile-sync'"

# Patching stuff
alias update-testing="salt -C 'G@os_family:RedHat and G@environment:testing' cmd.shell 'yum clean all && yum update -y'; salt -C 'G@os_family:Debian and G@environment:testing' cmd.run 'apt-get upgrade -y'; salt -C 'G@os_family:Suse and G@environment:testing' cmd.run 'zypper update --non-interactive'"
alias reboot-testing="salt -b 1 -G 'environment:testing' system.reboot"
alias update-dev="salt -C 'G@os_family:RedHat and G@environment:dev' cmd.shell 'yum clean all && yum update -y'; salt -C 'G@os_family:Debian and G@environment:dev' cmd.run 'apt-get upgrade -y'; salt -C 'G@os_family:Suse and G@environment:dev' cmd.run 'zypper update --non-interactive'"
alias reboot-dev="salt -b 1 -G 'environment:dev' system.reboot"
alias update-stage="salt -C 'G@os_family:RedHat and G@environment:stage' cmd.shell 'yum clean all && yum update -y'; salt -C 'G@os_family:Debian and G@environment:stage' cmd.run 'apt-get upgrade -y'; salt -C 'G@os_family:Suse and G@environment:stage' cmd.run 'zypper update --non-interactive'"
alias reboot-stage="salt -b 1 -G 'environment:stage' system.reboot"
alias update-production="salt -C 'G@os_family:RedHat and G@environment:production' cmd.shell 'yum clean all && yum update -y'; salt -C 'G@os_family:Debian and G@environment:production' cmd.run 'apt-get upgrade -y'; salt -C 'G@os_family:Suse and G@environment:production' cmd.run 'zypper update --non-interactive'"
alias reboot-production="salt -b 1 -G 'environment:production' system.reboot"


# # # # # # # # # #
# Aliases for git #
# # # # # # # # # #

alias g="git"
alias ga="git add --all"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gcol="git checkout live"
alias gcom="git checkout master"
alias gcos="git checkout stable"
alias gcou="git checkout upstream"
alias gd="git diff"
alias gl="git lg"
alias gm="git merge"
alias gp="git pull --ff"
alias gpol="git push origin live"
alias gpom="git push origin master"
alias gpos="git push origin stable"
alias gpou="git push origin upstream"
alias gs="git status"
alias gitgraph="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias git-yolo='git commit -am "`curl -s http://whatthecommit.com/index.txt`"'
alias git-friday-afternoon='git commit -a -m "obviously not a read-only friday"; git push --force'


# # # # # # #
# Functions #
# # # # # # #

# Print a remote server's SSL certificate to the terminal
function sslcert() {
  if [ "${1}" = "-h" ]; then
    echo "Usage: sslcert [FQDN]"
    echo "Prints SSL certificate of a remote server to the terminal."
    return
  fi
  echo | openssl s_client -showcerts -servername "$@" -connect "$*":443 2>/dev/null | openssl x509 -inform pem -noout -text
}

# Extract a file
function extract() {
  if [ "${1}" = "-h" ]; then
    echo "Usage: extract [filename]"
    echo "Extracts specified archive."
    return
  fi
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.Z) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.jar) unzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *) echo "'$1' cannot be extracted." ;;
    esac
    else
      echo "'$1' is not a file."
  fi
}

# RTFM
function rtfm() {
  if [ "${1}" = "-h" ]; then
    echo "Usage: rtfm [command]"
    echo "Returns [command] -h, or then the man page, or then Google search results"
    return
  fi
  "$@" --help 2> /dev/null || man "$@" 2> /dev/null || open 'http://www.google.com/search?q="$@"';
}

# What processes are listening on what ports?
function listening {
  if [ "${1}" = "-h" ]; then
    echo "Usage: listening [t|tcp|u|udp] [ps regex]"
    return
  fi
  DISP="both"
  NSOPTS="tu"
  if [ "${1}" = "t" -o "${1}" = "tcp" ]; then
    DISP="tcp"
    NSOPTS="t"
    shift
  elif [ "${1}" = "u" -o "${1}" = "udp" ]; then
    DISP="udp"
    NSOPTS="u"
    shift
  fi
  FILTER="${*}"
  PORTS_PIDS=$(netstat -"${NSOPTS}"lnp | tail -n +3 | tr -s ' ' | sed -n 's/\(tcp\|udp\) [0-9]* [0-9]* \(::\|0\.0\.0\.0\|127\.[0-9]*\.[0-9]*\.[0-9]*\):\([0-9]*\) .* \(-\|\([0-9-]*\)\/.*\)/\3 \1 \5 \2/p' | sed 's/\(::\|0\.0\.0\.0\)/EXTERNAL/' | sed 's/127\.[0-9]*\.[0-9]*\.[0-9]*/LOCALHOST/' | sort -n | tr ' ' ':' | sed 's/::/:-:/' | sed 's/:$//' | uniq)
  PS=$(ps -eo pid,args)
  echo -e '   Port - Protocol - Interface - Program\n-----------------------------------------------'
  for PORT_PID in ${PORTS_PIDS}; do
    PORT=$(echo "${PORT_PID}" | cut -d':' -f1)
    PROTOCOL=$(echo "${PORT_PID}" | cut -d':' -f2)
    PID=$(echo "${PORT_PID}" | cut -d':' -f3)
    INTERFACE=$(echo "${PORT_PID}" | cut -d':' -f4)
    if [ "${PROTOCOL}" != "${DISP}" -a "${DISP}" != "both" ]; then
      continue
    fi
    if [ "${PID}" = "-" ]; then
      if [ "${FILTER}" != "" ]; then
        continue
      fi
      printf "%7s - %8s - %9s - -\n" "${PORT}" "${PROTOCOL}" "${INTERFACE}"
    else
      PROG=$(echo "${PS}" | grep "^ *${PID}" | grep -o '[0-9] .*' | cut -d' ' -f2-)
      if [ "${FILTER}" != "" ]; then
        echo "${PROG}" | grep -q "${FILTER}"
        if [ $? -ne 0 ]; then
          continue
        fi
      fi
      printf "%7s - %8s - %9s - %s\n" "${PORT}" "${PROTOCOL}" "${INTERFACE}" "${PROG}"
    fi
  done
}

# What processes have open files?
function openfiles {
  if [ "${1}" = "-h" ]; then
    echo -e "Usage: openfiles [r|w|m|R|W] regex\n    -r    opened for reading or read/write\n    -w    opened for writing or read/write\n    -m    accessed from memory (includes running command)\n    -R    opened for reading only\n    -W    opened for writing only"
    return
  fi
  if [ "$#" = "0" ]; then
    echo "Process signature/regex required."
    return
  fi
  MODE="(w|u)"
  ACTION="for writing"
  if [ "${1}" = "r" ]; then
    MODE="(r|u)"
    ACTION="for reading"
    shift
  elif [ "${1}" = "R" ]; then
    MODE="r"
    ACTION="for reading (only)"
    shift
  elif [ "${1}" = "W" ]; then
    MODE="w"
    ACTION="for writing (only)"
    shift
  elif [ "${1}" = "m" ]; then
    MODE="(txt|mem)"
    ACTION="in memory"
    shift
  elif [ "${1}" = "w" ]; then
    shift
  fi
  if [ "${MODE}" != "(txt|mem)" ]; then
    MODE="[0-9]+${MODE}"
  fi
  PIDS=$(pgrep -d "," -f "${@}")
  if [ "${PIDS}" = "" ]; then
    echo "No processes found matching '${@}'."
    return
  fi
  OPENFILES=$(lsof -PXn -p "${PIDS}" | egrep "${MODE}[A-Za-z]* +REG" | awk '{print $9}' | egrep -v "^\[" | sort | uniq);
  if [ "${OPENFILES}" = "" ]; then
    echo "No files opened ${ACTION}."
  else
    echo "Files opened ${ACTION}:"
    ls -ahl "$OPENFILES"
  fi
}

# Color man pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
      man "$@"
}

# IP info
ipif() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
  curl ipinfo.io/"$1"
    else
  ipawk=($(host "$1" | awk '/address/ { print $NF }'))
  curl ipinfo.io/${ipawk[1]}
    fi
    echo
}

# Syntax highlighting in cat (using Pygments, installed with pip)
cat() {
    local out colored
    out=$(/bin/cat $@)
    colored=$(echo $out | pygmentize -f console -g 2>/dev/null)
    [[ -n $colored ]] && echo "$colored" || echo "$out"
}

# Helper function for pp
function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

# Show all processes owned by me
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

# Get IP address
function myip() {
  IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;
  echo $IP
}

# Get current host related info
function ii() {
  echo -e "\nYou are logged on ${BLUE}$HOSTNAME${NC}"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo
}

# Because.
fliptable(){ echo "（╯°□°）╯ ┻━┻"; }
shrug(){ echo " ¯\_(ツ)_/¯ "; }

# Update all the things (may need elevated privileges in Linux)
function updates() {
  if [ $OSTYPE = "darwin16" ] ; then
    softwareupdate -li
    if [ -f /usr/local/bin/brew ] ; then
      brew update && brew upgrade -y
    fi
    if [ -f /usr/local/bin/pip ] ; then
      pip2 install --upgrade pip && pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install -U
    fi
    if [ -f /usr/local/bin/pip3 ] ; then
      pip3 install --upgrade pip && pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install -U
    fi
    if [ -f /usr/local/bin/gem ] ; then
      gem update
    fi
  elif [ $OSTYPE = "linux-gnu" ] ; then
    if grep -q "Ubuntu\|Debian" "/etc/os-release" ; then
      apt-get clean && apt-get update && apt-get dist-upgrade -y && apt-get autoremove
    fi
    if grep -q "CentOS\|Red Hat" "/etc/redhat-release" ; then
      yum clean all && yum update -y
    fi
    if grep -q "SUSE\|SLES" "/etc/os-release" ; then
      zypper ref -s && zypper update --skip-interactive -l -y
    fi
  else
    echo "no idea what to do here ... exiting"
  fi
}
