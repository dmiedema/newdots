#!/usr/bin/env bash
echo "Creating src directory"
mkdir -p ~/src

# Install dependencies/tools
echo "Installing vim-plug & zgen"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [[ ! -d "$HOME/.zgen" ]]; then
  git clone https://github.com/tarjoilija/zgen ~/.zgen
else
  zgen update
fi

# Clone repos
if [[ ! -d "$HOME/src/vimrc" ]]; then
  git clone https://github.com/dmiedema/vimrc.git ~/src/vimrc
else
  pushd ~/src/vimrc; git pull; popd
fi
if [[ ! -d "$HOME/src/zshrc" ]]; then
  git clone https://github.com/dmiedema/zshrc.git ~/src/zshrc
else
  pushd ~/src/zshrc; git pull; popd;
fi
if [[ ! -d "$HOME/src/tmux" ]]; then
  git clone https://github.com/dmiedema/tmux.conf.git ~/src/tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  pushd ~/src/tmux; git pull; popd;
fi

# Link dotfiles
echo "Linking dotfiles"
if [[ ! -a "$HOME/.vimrc" ]]; then
  ln -s ~/src/vimrc/vimrc "$HOME/.vimrc"
  ln -s ~/src/vimrc/vimrc.bundles "$HOME/.vimrc.bundles"
fi
if [[ ! -a "$HOME/.zshrc" ]]; then
  ln -s ~/src/zshrc/zshrc "$HOME/.zshrc"
fi
if [[ ! -a "$HOME/.tmux.conf" ]]; then
  ln -s ~/src/tmux.conf/tmux.conf "$HOME/.tmux.conf"
fi
if [[ ! -a "$HOME/.tmuxlinesnapshot.conf" ]]; then
  ln -s ~/src/tmux.conf/tmuxlinesnapshot.conf.wombat256 "$HOME/.tmuxlinesnapshot.conf"
fi

function __add_swift_to_zshrc_local() {
  echo "export PATH=/usr/share/src/swift/usr/bin:$PATH" >> "$HOME/.zshrc.local"
}

if [[ "$OSTYPE" != "darwin"* ]]; then
  SWIFT_INSTALLED=$(which swift &> /dev/null)
  if [[ $SWIFT_INSTALLED ]]; then
    if [[ -a "$HOME/.zshrc.local" ]]; then
      IN_ZSHRC_LOCAL=$(grep -c 'swift' "$HOME/.zshrc.local")
      if [[ $IN_ZSHRC_LOCAL -eq 0 ]]; then
        __add_swift_to_zshrc_local
      fi
    else
      __add_swift_to_zshrc_local
    fi
  fi # SWIFT_INSTALLED
fi # not darwin platform

echo "Installing Vim Plugins"
vim +PlugInstall +qall

zsh # run ZSH to clone the repos down

