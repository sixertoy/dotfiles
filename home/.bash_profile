#!/bin/bash

# ----------------------------
#
# Default Environment Path
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/opt/X11/bin
export PATH

# add MySQL executables bin folder to $PATH
PATH="/usr/local/mysql/bin:$PATH"

# add NPM executables bin folder to $PATH
PATH="$HOME/.npm-packages/bin:$PATH"

# add current user executables bin folder to $PATH
PATH="$HOME/bin:$PATH"

# ------------------------------------------------
#
# Node Version Manager
# @see https://github.com/creationix/nvm#manual-install
#
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Load NVM completion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
#
# ------------------------------------------------

# Add NPM to $NODE_PATH variables
# NODE_PATH="$NPM_PACKAGES_PATH/lib/node_modules:$NODE_PATH"

# Sublime Text as default editor
# export EDITOR='subl -w'

# Load the shell dotfiles
for file in ~/.{bash_completion,aliases,functions,gitprompt,gitcompletion,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;
