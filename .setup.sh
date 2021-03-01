#!/bin/bash

export grey="\e[1;30m"
export red="\e[1;31m"
export green="\e[1;32m"
export yellow="\e[1;33m"
export blue="\e[1;34m"
export unset_color="\e[0m"

description () {
  echo "--- $* ---"
}

call_root () {
  echo -e "$red*** Request for root privellege. ***$unset_color"
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

warn () {
  echo -e "$red$*$unset_color"
}

interact () {
  printf "$yellow$*$unset_color"
}

test_exists () {
  if [[ ! -e "$1" ]]; then
    warn "Can't find $1, please check ./customize or your system enviroments."
    exit 1
  else
    echo "$1 exists."
  fi
}

pause () {
  echo -e "$blue*** Press any key to continue... (^C to quit) ***$unset_color"
  read -s -n1 -p ""
}

mirror () {
  echo -e "$grey$(echo -e $* | sed '/^[[:space:]]*$/d')$unset_color"
}

if [[ "$SETUPPY" -ne "1" ]]; then
  warn "PLEASE RUN THIS SCRIPT BY setup.py!!"
  exit -1
fi

description "dotfiles .setup.sh"

# Enable aliases
shopt -s expand_aliases

# Check and source ./customize
if [[ ! -e ./customize ]]; then
  warn "Lost ./customize. Please reclone this repo."
  exit -1
fi
source ./customize

# Test hello world
echo $HELLO_WORLD

# Check Python3
description "Check Python3"
alias python="$PYTHON3_PATH/python3"
mirror $(alias python)
test_exists "$PYTHON3_PATH/python3"
python --version

# Get environment variables
description "Get environment variables"
python -c "import os; print(os.environ)"

pause

# For different OS
# DISTRO_PM 1=apt,2=dnf,3=pacman,0 for darwin
description "Install foundations"
case "$DISTRO_PM" in
  0)  echo "You are macOS."
      ;;
  1)  echo "You are using apt."
      call_root

      description "Use China Aliyun sources"
      sudo sed -e 's|cn.archive.ubuntu.com|mirrors.aliyun.com|g' \
        -e 's|archive.ubuntu.com|mirrors.aliyun.com|g' \
        -e 's|security.ubuntu.com|mirrors.aliyun.com|g' \
        -i.bak \
        /etc/apt/sources.list
      
      sudo apt update
      sudo apt install -y gcc g++ \
        git wget curl zsh proxychains openssh-server \
	vim emacs gnome-tweak-tool \
	;
      
      ;;
  2)  echo "You are using dnf."
      call_root
      sudo sed -e 's|^metalink=|#metalink=|g' \
        -e 's|^#baseurl=http://download.example/pub/fedora/linux|http://mirrors.aliyun.com/fedora|g' \
        -i.bak \
        /etc/yum.repos.d/fedora.repo \
        /etc/yum.repos.d/fedora-modular.repo \
        /etc/yum.repos.d/fedora-updates.repo \
        /etc/yum.repos.d/fedora-updates-modular.repo
      ;;
  3)  echo "You are using pacman."
      call_root
      ;;
esac

# Set proxy address
description "Set proxy address"
# Display network info
which ip > /dev/null
if [[ "$?" -eq "0" ]]; then
  ip addr
else
  which ifconfig > /dev/null
  if [[ "$?" -eq "0" ]]; then
    ifconfig
  else
    warn "Neither \`ip\` nor \`ifconfig\` is installed."
  fi
fi

interact "Set proxy ip (default is $PROXY_IP_DEFAULT and enter to skip):\n"
read PROXY_IP
if [[ -z $PROXY_IP ]]; then
  PROXY_IP=$PROXY_IP_DEFAULT
fi
interact "Set proxy port (default is $PROXY_PORT_DEFAULT and enter to skip):\n"
read PROXY_PORT
if [[ -z $PROXY_PORT ]]; then
  PROXY_PORT=$PROXY_PORT_DEFAULT
fi
echo -e "Your proxy address is $green$PROXY_IP:$PROXY_PORT$unset_color"

# Proxy write into shell RCs and proxychains config
description "Apply proxy"
echo -e "Your HOME directory is $green$HOME$unset_color"

echo -e "Write proxy commands into $green$HOME/.bashrc$unset_color"
export PROXY_PREFIX_COMMAND="https_proxy=$PROXY_IP:$PROXY_PORT http_proxy=$PROXY_IP:$PROXY_PORT"
export PROXY_COMMAND="export $PROXY_PREFIX_COMMAND"
export PROXY_RC="\nalias proxy=\"$PROXY_COMMAND\"\nalias proxy_prefix=\"$PROXY_PREFIX_COMMAND\"\nalias p=proxy_prefix"

echo -e "$PROXY_RC" >> $HOME/.bashrc
mirror "$PROXY_RC"

if [[ "$SYS" == "linux" ]]; then
  sudo sed -i '$d' /etc/proxychains.conf
  sudo PROXY_IP=$PROXY_IP PROXY_PORT=$PROXY_PORT sh -c 'echo "http $PROXY_IP $PROXY_PORT" >> /etc/proxychains.conf'
fi

# Enable sshd on Systemd Linux
description "Enable sshd"
if [[ "$SYS" == "linux" ]]; then
  sudo systemctl enable sshd
fi

# Git
description "Config git"
interact "Git name (default is $GIT_NAME_DEFAULT and enter to skip):\n"
read GIT_NAME
if [[ -z $GIT_NAME ]]; then
  GIT_NAME=$GIT_NAME_DEFAULT
fi
interact "Git email (deafult is $GIT_EMAIL_DEFAULT and enter to skip):\n"
read GIT_EMAIL
if [[ -z $GIT_EMAIL ]]; then
  GIT_EMAIL=$GIT_EMAIL_DEFAULT
fi

export GITCONFIG="\
[user]\n\
  name = $GIT_NAME\n\
  email = $GIT_EMAIL\n\
[http]\n\
  proxy = $PROXY_IP:$PROXY_PORT\n\
[https]\n\
  proxy = $PROXY_IP:$PROXY_PORT\n\
"

echo -e $GITCONFIG > $HOME/.gitconfig
mirror $GITCONFIG

# SSH key
description "SSH key generate"
interact "Do you want to generate ssh key?(y/N) "
read skg_choice
case $skg_choice in
  [yY]) echo -e "ssh-keygen -t rsa -C $GIT_EMAIL"
        ssh-keygen -t rsa -C $GIT_EMAIL;;
esac
