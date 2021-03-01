#!/bin/bash

description () {
  echo "--- $* ---"
}

test_exists () {
  if [[ ! -e "$1" ]]; then
    echo "Can't find $1, please check ./customize or your system enviroments."
    exit 1
  else
    echo "$1 exists."
  fi
}

if [[ "$SETUPPY" -ne "1" ]]; then
  echo "PLEASE RUN THIS SCRIPT BY setup.py!!"
  exit -1
fi

description "dotfiles .setup.sh"

# Enable aliases
shopt -s expand_aliases

# Check and source ./customize
if [[ ! -e ./customize ]]; then
  echo "Lost ./customize. Please reclone this repo."
  exit -1
fi
source ./customize

# Test hello world
echo $HELLO_WORLD

# Check Python3
description "Check Python3"
alias python="$PYTHON3_PATH/python3"
alias python
test_exists "$PYTHON3_PATH/python3"
python --version

# Get environment variables
description "Get environment variables"
python -c "import os; print(os.environ)"
