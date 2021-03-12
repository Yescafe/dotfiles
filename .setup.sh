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

      description "Use USTC sources"
      sudo sed -i 's/cn.archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
      sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
      sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
      
      sudo apt update
      sudo apt install -y gcc \
        git wget curl zsh proxychains openssh-server \
        vim emacs gnome-tweak-tool \
        socat python3 python3-pip \
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

# Proxy write into shell RCs, proxychains config, git config
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

echo -e "Write proxy config into $green$HOME/.ssh/config$unset_color for github.com"
mkdir -p $HOME/.ssh
export PROXY_GIT_SOCAT_CONFIG="Host github.com\n  User git\n  ProxyCommand socat - PROXY:$PROXY_IP:%h:%p,proxyport=$PROXY_PORT"
echo -e "$PROXY_GIT_SOCAT_CONFIG" > $HOME/.ssh/config
mirror "$PROXY_GIT_SOCAT_CONFIG"
pause

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

# ZSH
description "Configure ZSH"
export http_proxy="$PROXY_IP:$PROXY_PORT"
export https_proxy="$PROXY_IP:$PROXY_PORT"

git clone -c core.eol=lf -c core.autocrlf=false \
  -c fsck.zeroPaddedFilemode=ignore \
  -c fetch.fsck.zeroPaddedFilemode=ignore \
  -c receive.fsck.zeroPaddedFilemode=ignore \
  --depth=1 --branch master https://github.com/ohmyzsh/ohmyzsh.git \
  "$HOME/.oh-my-zsh"

interact "chsh -s $(which zsh)\n"
sudo chsh -s $(which zsh) $(whoami)

if [[ "$SYS" == "linux" ]]; then  # Linux
  ln -s $PWD/zsh/linux.zshrc $HOME/.zshrc
  sed -i 's|__IP|'$PROXY_IP'|g' $PWD/zsh/linux.zshrc
  sed -i 's|__PORT|'$PROXY_PORT'|g' $PWD/zsh/linux.zshrc
  sed -i 's|__HOME|'$HOME'|g' $PWD/zsh/linux.zshrc
else  # macOS
  ln -s $PWD/zsh/darwin.zshrc $HOME/.zshrc
  gsed -i 's|__IP|'$PROXY_IP'|g' $PWD/zsh/darwin.zshrc
  gsed -i 's|__PORT|'$PROXY_PORT'|g' $PWD/zsh/darwin.zshrc
  gsed -i 's|__HOME|'$HOME'|g' $PWD/zsh/darwin.zshrc
fi

# source $HOME/.zshrc
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

if [[ "$SYS" == "darwin" ]]; then # only for macOS
  description "Install CL tools for macOS"
  # TODO
fi

cp $PWD/zsh/p10k.zsh $HOME/.p10k.zsh

# Vim
description "Configure Vim"
ln -s $PWD/vim/vimrc $HOME/.vimrc
git clone https://github.com/jacoborus/tender.vim $HOME/.vim/pack/vendor/start/tendor
git clone https://github.com/scrooloose/nerdtree $HOME/.vim/pack/vendor/start/nerdtree
git clone https://github.com/lvht/fzf $HOME/.vim/pack/vendor/start/fzf
git clone https://github.com/lvht/mru $HOME/.vim/pack/vendor/start/mru
git clone https://github.com/mileszs/ack.vim $HOME/.vim/pack/vendor/start/ack

if [[ "$DO_YOU_LIKE_INSTALLING_RUBY" -eq "true" ]]; then
  # RVM
  description "Configure RVM"
  gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  if [[ "$?" -ne 0 ]]; then
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  fi
  curl -sSL https://get.rvm.io | bash

  # irbrc
  description "Configure Ruby CLI"
  ln -s $PWD/ruby/irbrc $HOME/.irbrc
fi

# pip
description "Configure pip mirror"
mkdir -p $HOME/.pip
ln -s $PWD/python/pip.conf $HOME/.pip/pip.conf

# Anaconda
description "Congiure conda"
ln -s $PWD/python/condarc $HOME/.condarc

# thefuck
description "Install thefuck"
sudo pip3 install thefuck

# Emacs
description "Clone emacs.d"
git clone https://github.com/Yescafe/emacs.d $HOME/.emacs.d
