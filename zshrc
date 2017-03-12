# Environment Variables
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Mysql/psql pagging support
export PAGER=less
export LESS="-iMx4 -FX"

# History related stuff
export HISTSIZE=5000
export SAVEHIST=5000
export HISTFILE=~/.zsh_history
setopt hist_ignore_dups        # ignore same commands run twice+
setopt appendhistory           # don't overwrite history
#setopt share_history

setopt nobeep
setopt autocd                  # change to dirs without cd
setopt correct                 # spelling correction
setopt extendedglob            # weird & wacky pattern matching - yay zsh!
setopt histverify              # when using ! cmds, confirm first
setopt interactivecomments     # escape commands so i can use them later

# Set xterm title
case $TERM in (xterm*|rxvt)
  precmd () { print -Pn "\e]0;%n@%m: %~\a" }
  preexec () { print -Pn "\e]0;%n@%m: $1\a" }
  ;;
esac

# Show branch name
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '(%F{cyan}%b%f|%F{magenta}%a%f) '
zstyle ':vcs_info:*' formats '(%F{cyan}%b%f) '
zstyle ':vcs_info:*' enable git
precmd () { vcs_info }

# Set prompt with branch name (%n@%m:%0~ ${vcs_info_msg_0_} %# ')
PS1='%F{green}%B%n%b%f@%F{green}%m%f:%F{blue}%0~%f ${vcs_info_msg_0_}%# '

# Aliases
alias diff='colordiff'

# Keymap
bindkey '^[[3~' delete-char    # del
#bindkey '^[[D'  backward-word  # alt+left
#bindkey '^[[C'  forward-word   # alt+right

# Use modern completion system
autoload -Uz compinit
compinit

# Autocompletions
LS_COLORS='no=00:fi=00:di=00;34:ln=01;34:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.bz2=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.sit=01;31:*.hqx=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.mov=01;35:*.app=01;33:*.c=00;33:*.php=00;33:*.pl=00;33:*.cgi=00;33:'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

umask 002

# OS specific stuff
os=$(uname)
case ${os} in
    Darwin)
        alias ls='ls -FG'
        alias la='ls -aFG'
        alias ll='ls -laG'
        ;;

    Linux)
        alias ls='ls -F --color=auto'
        alias la='ls -aF --color=auto'
        alias ll='ls -la --color=auto'
        ;;
esac


# Local Settings
if [[ -s $HOME/.zshrc_local ]] ; then source $HOME/.zshrc_local ; fi
