# -----------------------------------
#
# GIT Functions
#
function git-name {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function git-desc {
        branch=$(git rev-parse --abbrev-ref HEAD)
        desc=$(git config branch.$branch.description)
        echo -e "> $desc"
}

function git-br {
  branches=$(git for-each-ref --format='%(refname)' refs/heads/ | sed 's|refs/heads/||')
  for branch in $branches; do
    desc=$(git config branch.$branch.description)
    if [ $branch == $(git rev-parse --abbrev-ref HEAD) ]; then
      branch="* \033[0;32m$branch\033[0m"
     else
       branch="  $branch"
     fi
     echo -e "$branch \033[0;36m$desc\033[0m"
  done
}


# ----------------------------------------
#
# Browserify fix parallel files limit
#
ulimit -n 2560

# ----------------------------------------
#
# Aliases
#
alias ll='ls -lA'
alias lds='df -h'
alias reload='source ~/.bash_profile'
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'"

# --------------------------------------
#
# toggle system hidden files visibility
# http://ianlunn.co.uk/articles/quickly-showhide-hidden-files-mac-os-x-mavericks/
#
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# --------------------------------------
#
# First Line Console
#
export PS1="\[\033[01;36m\]\u@\h:\[\033[01;34m\]\$(git-name) \[\033[01;32m\]\w \[\033[01;34m\]\n$ \[\e[0m\]"

# ----------------------------------------
#
# Charge le fichier bashrc
# ce fichier contient les PATH pour les apps nodejs
#
source ~/.bashrc
