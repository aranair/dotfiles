# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH=$HOME/.oh-my-zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source $ZSH/oh-my-zsh.sh

prompt_context () { true; }

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

alias k="kubectl"
alias ks="kubectl -n kube-system"
alias gl="git pull"
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gpo="git push origin"
alias gpof="git push origin --force-with-lease"
alias gph="git push heroku"
alias grh="git reset HEAD"
alias stree='open -a SourceTree .'
alias be="bundle exec"
alias syn='git branch --merged | grep -v "\*" | grep -v master | grep -v development | xargs -n 1 git branch -d'
alias tl="cd ~/Projects/tulip"
alias tlf="cd ~/Projects/tulip/environments/cloud/Central/factory"
alias tlm="cd ~/Projects/tulip/environments/cloud/services/src/tulip/migrations"
alias tlh="cd ~/Projects/tulip/environments/cloud/kubernetes/helm"
alias tlw="cd ~/Projects/tulip/environments/cloud/services/src/tulip/tulipweb/"
alias tlc='cd ~/Projects/cotton'
alias ts='tailscale'
alias cl='claude --allow-dangerously-skip-permissions'
alias rm='trash'
alias darkmode='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"'
alias b='but'

# Bat / Fzf
alias b="bat"
alias ff="fzf --preview 'bat --color \"always\" {}'"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'"
function fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# tmux alias
alias tmux="TERM=screen-256color-bce tmux"
alias ta="tmux a -t"
alias tn="tmux new -s"

export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# GO
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$GOBIN"

# Elixir
export PATH="$PATH:/path/to/elixir/bin"

# Ruby
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NOTES_DIRECTORY="/Users/homan/Dropbox/notes"

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

# FZF
export FZF_DEFAULT_COMMAND='
  (git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'

autoload -U +X bashcompinit && bashcompinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$PATH:/Users/homan/.avail/bin"
export PATH="/opt/homebrew/opt/trash-cli/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# GitButler CLI completions
eval "$(but completions zsh)"
