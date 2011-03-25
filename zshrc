### Environment Variables
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH

# locale
export LC_ALL=ru_RU.UTF-8
export LANG=ru_RU.UTF-8

# php
export PATH=/opt/php/bin:/opt/php/sbin:/opt/php/lib/php:$PATH

#mysql/psql pagging support
export PAGER=less
export LESS="-iMSx4 -FX"

### history related stuff.
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

# set a fancy prompt ('%n@%m %~ %# ')
PS1=$'%{\e[01;32m%}%n%{\e[00;32m%}@%m%{\e[00m%} %{\e[01;34m%}%0~%{\e[00;30m%} %# %{\e[00m%}'

### Aliases
alias ls='ls -FG'
alias la='ls -aFG'
alias ll='ls -laG'
alias diff='colordiff'


# set up some directory variables. i can then do cd ms to land in my music dir
# emacs understands these too.
export src=/usr/local/src
export r=/var/www/data/repos
: src r

# Colorize osx ls
export CLICOLOR="true"
export LSCOLORS="exfxcxdxbxegedabagacad"

# keymap
bindkey '^[[3~' delete-char    # del
#bindkey '^[[D'  backward-word  # alt+left
#bindkey '^[[C'  forward-word   # alt+right


# Compinit initializes various advanced completions for zsh
autoload -U compinit; compinit

# Autocompletions
LS_COLORS='no=00:fi=00:di=00;34:ln=01;34:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.bz2=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.sit=01;31:*.hqx=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.mov=01;35:*.app=01;33:*.c=00;33:*.php=00;33:*.pl=00;33:*.cgi=00;33:'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

umask 002

# Local Settings
if [[ -s $HOME/.zshrc_local ]] ; then source $HOME/.zshrc_local ; fi