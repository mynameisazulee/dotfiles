# GIT ALIASES
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gblm='git blame'
alias gb='git branch'
alias gc='git checkout'
alias gdb='git branch -d'
alias gremote='git remote'
alias gf='git fetch'
# alias gp='git pull'
alias gp='git pull --rebase --autostash'
alias gpush='git push'
alias gm='git merge'
alias gmt='git mergetool'
alias grebase='git rebase'
alias ghr='git reset --hard HEAD'     # Git hard reset
alias ghrf='git checkout HEAD --'     # Git hard reset single file
alias gsr='git reset --soft HEAD'
alias guc='git reset HEAD~'       # git undo commit
alias gupc='git revert HEAD'      # git undo public commit
alias gl='git log --graph --pretty=oneline --abbrev-commit'
alias gsq='git reset --soft "HEAD^" && git commit --amend' # squash two commits

# LINUX ALIASES
alias ls='ls -F'

# TMUX ALIASES
alias t='tmux ls'
alias ts='tmux new -s'
alias ta='tmux a -t'
alias tk='tmux kill-session -t'

# SCREEN ALIAS
alias s='screen -ls'
alias ss='screen -S'
alias sa='screen -r'

# EMACS ALIAS
alias e='emacs'

# USE PYTHON3
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'
