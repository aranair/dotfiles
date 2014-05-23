## Steps

1. Set up [Vundle]:

   `$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

2. Symlink vimrc file
    * `git clone git@github.com:aranair/dotfiles.git ~/dotfiles`
    * `ln -s ~/dotfiles/vimrc ~/.vimrc` 
    * alternatively, just update your ~/.vimrc file
3. Install Plugins:

   Launch `vim` and run `:PluginInstall`

   To install from command line: `vim +PluginInstall +qall`
   
4. Install [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) (for Ag)

   `brew install the_silver_searcher`

5. Add the following to your .bash_profile or .zshrc 
   ```
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   ```

6. Put solarized colors into ~/.vim/colors
7. 
   `cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/`

7. Profit!!!

## Sample Commands

1. `<Space>w` writes to file (save)
2. `<Space>e` write+quit
3. `<Space>t` new tab
4. `<Ctrl-n>` Open Nerdtree File Browsing (https://github.com/scrooloose/nerdtree)
5. `<Ctrl-f>` Search text using Ag (https://github.com/rking/ag.vim)
6. `<Ctrl-p>` Fuzzy file finder (https://github.com/kien/ctrlp.vim)
