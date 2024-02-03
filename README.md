## Auto

`./fresh-setup.sh`

## Manual

1. Set up [Vim-Plug]
2. Symlink file(s)
    * `git clone git@github.com:aranair/dotfiles.git ~/dotfiles`
    * `ln -s ~/dotfiles/vimrc ~/.vimrc` and `ln -s ~/dotfiles/tmux.conf ~/.tmux.conf`
    * alternatively, just copy and paste into your ~/.vimrc file
   
3. Install Plugins:

   Launch `vim` and run `:PlugInstall`

   To install from command line: `vim +PlugInstall +qall`
   
4. Install [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) (for Ag)

   `brew install the_silver_searcher`

5. Add the following to your .bash_profile or .zshrc 
   ```
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   ```

6. Put solarized colors into ~/.vim/colors
 
   - `cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/` OR
   - `cp ~/dotfiles/Monokai.vim ~/.vim/colors/`

7. Find the right color profile for iTerm if you're using that.
 
   `https://github.com/mbadolato/iTerm2-Color-Schemes

8. (If you want) Brew Install tmux + reattach-to-user-namespace
   * `brew install tmux`
   * `brew install reattach-to-user-namespace`

## Optionals (for myself)

9. Install zsh to override default one 
 
   `brew install zsh`

10. Install oh-my-zsh and copy over zshrc

   `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`


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

