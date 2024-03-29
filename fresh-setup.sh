#!/bin/sh

# Exit immediately if any command returns a non-zero status
set -eou pipefail

which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

which -s git || brew install git

# Terminal stuff
brew install vim
brew install the_silver_searcher
brew install zsh
brew install tmux
brew install tmuxinator
brew install reattach-to-user-namespace
brew install bat

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir -p ~/.vim/autoload
cp plug.vim ~/.vim/autoload/plug.vim
git clone git@github.com:aranair/dotfiles.git ~/dotfiles

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

# Do not change this to a symlink
cp ~/dotfiles/.zshrc ~/.zshrc
cp ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json

# vim-plug
vim +PlugInstall +qall

mkdir -p ~/.vim/swp
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/colors

cp ~/dotfiles/Monokai.vim ~/.vim/colors/
cp ~/dotfiles/Northland.vim ~/.vim/colors/

# Notes
NOTES_VERSION=1.1.0
TMP_PATH=/tmp/notes-dl
curl -L https://github.com/pimterry/notes/archive/refs/tags/${NOTES_VERSION}.tar.gz -O && \
  echo "160f7d5a46c8a8654241a532a5e14e128d6c832b547bfd38653dc78f06964c03  ${NOTES_VERSION}.tar.gz" | \
  shasum -a 256 -c && \
  tar xzf ${NOTES_VERSION}.tar.gz -C $TMP_PATH --strip-components=1 && rm ${NOTES_VERSION}.tar.gz

cd $TMP_PATH && make USERDIR=$(eval echo ~$SUDO_USER)

curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/notes > /usr/local/bin/notes && chmod +x /usr/local/bin/notes
curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/_notes > /usr/local/share/zsh/site-functions/_notes
