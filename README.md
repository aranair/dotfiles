## Steps

1. Set up [Vundle]:

   `$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

2. Symlink file(s)
    * `git clone git@github.com:aranair/dotfiles.git ~/dotfiles`
    * `ln -s ~/dotfiles/vimrc ~/.vimrc` and `ln -s ~/dotfiles/tmux.conf ~/.tmux.conf`
    * alternatively, just copy and paste into your ~/.vimrc file
   
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
 
   `cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/`

7. Find the right color profile for iTerm if you're using that.
 
   `https://github.com/mbadolato/iTerm2-Color-Schemes

8. (If you want) Brew Install tmux + reattach-to-user-namespace
   * `brew install tmux`
   * `brew install reattach-to-user-namespace`

## Sample Commands

1.  `<Space>w` writes to file (save)
2.  `<Space>q` quit
3.  `<Space>e` write + quit
4.  `<Space>t` new tab
5.  `<Space>y` copy to clipboard
6.  `<Space>p` paste from clipboard
7.  `<Ctrl-n>` Open Nerdtree File Browsing (https://github.com/scrooloose/nerdtree)
8.  `<Ctrl-f>` Search text using Ag (https://github.com/rking/ag.vim)
9.  `<Ctrl-p>` Fuzzy file finder (https://github.com/kien/ctrlp.vim)
10. `<Space>z` Puts you in distract free mode

