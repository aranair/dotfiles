ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="af-magic"
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

alias gl="git pull"
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gpo="git push origin"
alias gph="git push heroku"
alias stree='open -a SourceTree .'
alias tsu="cd ~/Projects/tsubasa"
alias caba="cd ~/Projects/carebear"
alias hot="cd ~/Projects/hoteru"
alias be="bundle exec"

# tmux alias
alias tmux="TERM=screen-256color-bce tmux"
alias ta="tmux a -t"
alias tn="tmux new -s"

export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/Users/admin/.rvm/gems/ruby-2.0.0-p451/bin:/Users/admin/.rvm/gems/ruby-2.0.0-p451@global/bin:/Users/admin/.rvm/rubies/ruby-2.0.0-p451/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/admin/.rvm/bin"

# Opens the github page for the current git repository in your browser
function gh() {
  giturl=$(git config --get remote.origin.url)
  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/\.git/\/tree/}
  # branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch="$(git rev-parse --abbrev-ref HEAD)" ||
  branch="(unnamed branch)"     # detached HEAD
  branch=${branch##refs/heads/}
  giturl=$giturl$branch
  open $giturl
}

# Opens the github page for current git repo and compares it -> for a new PR.
function newpr() {
  giturl=$(git config --get remote.origin.url)
  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/\.git/\/compare/}
  branch="$(git rev-parse --abbrev-ref HEAD)" ||
  branch="(unnamed branch)"     # detached HEAD
  branch=${branch##refs/heads/}
  giturl=$giturl$branch
  open $giturl
}
# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"