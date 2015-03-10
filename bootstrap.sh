#!/usr/bin/env bash

####
#
# Setup & helper functions
#
####
exists() {
  if command -v "$1" &> /dev/null; then
    return 1
  else
    return 0
  fi
}

msg() {
  printf '%b\n' "$1" >&2
}

success() {
  if [ "$ret" -eq 0 ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
  fi
}

notice() {
  msg "\e[33m[!]\e[0m ${1}${2}"
}

error() {
  msg "\e[31m[✘]\e[0m ${1}${2}"
  exit 1
}

####
#
# Actual bootstrapping
#
####

####
# Verify Prewrecks
####
exists git
GIT_EXISTS=$?

if [ ! "$GIT_EXISTS" ]; then
  error "git is required"
fi

exists antigen
ANTIGEN_EXISTS=$?

if [ ! "$ANTIGEN_EXISTS" ]; then
  notice "installing antigen..."
  git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"
fi

exists lsrc
RCM_EXISTS=$?

if [ ! "$RCM_EXISTS" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    exists brew
    if [ ! $? ]; then
      error "I need homebrew plz"
    fi
    brew tap thoughtbot/formulae
    brew install rcm
    brew install tmux vim zsh mosh xctool
  else # not on OS X
    notice "Installation of rcm is not automated"
    notice "https://github.com/thoughtbot/rcm"
    error "Please install RCM and rerun me"
fi # RCM is installed

exists tmux
TMUX_EXISTS=$?

if [ ! "$TMUX_EXISTS" ]; then
  notice "tmux is recommended but not required. It is currently not instaled"
fi

git clone https://github.com/dmiedema/vimrc "$HOME/.dotfiles.vimrc"
git clone https://github.com/dmiedema/zshrc "$HOME/.dotfiles.zshrc"
git clone https://github.com/dmiedema/tmux.conf "$HOME/.dotfiles.tmux.conf"


# clone the other repos, tmux, zsh, vimrc & link them
