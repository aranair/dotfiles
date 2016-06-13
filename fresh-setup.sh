#!/bin/sh

# Exit immediately if any command returns a non-zero status
set -e

which -s brew
if [[ $? != 0 ]] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

which -s git || brew install git

# Terminal stuff
brew install vim
brew install the_silver_searcher
brew install zsh
brew install tmux
brew install reattach-to-user-namespace

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone git@github.com:aranair/dotfiles.git ~/dotfiles

ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
cp ~/dotfiles/zshrc ~/.zshrc

vim +PluginInstall +qall

if [ ! -d "~/.vim/swp" ]; then
  mkdir ~/.vim/swp
fi

if [ ! -d "~/.vim/backup" ]; then
  mkdir ~/.vim/backup
fi

if [ ! -d "~/.vim/colors" ]; then
  mkdir ~/.vim/colors
fi

cp ~/dotfiles/Monokai.vim ~/.vim/colors/

# GIT
echo -e "\n\n\n" ssh-keygen -t rsa -b 4096 -C "boa.homan@gmail.com"
# ssh-keygen -t rsa -b 4096 -C "comment" -P "examplePassphrase" -f "desired pathAndName" -q 
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# RVM
\curl -sSL https://get.rvm.io | bash -s stable --ruby
