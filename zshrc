# vim: set ft=zsh:

######################################
# zsh initialization
######################################
autoload -Uz compinit && compinit
setopt histignorealldups
autoload history-search-end
setopt list_packed
setopt nolistbeep
setopt auto_cd
setopt pushd_ignore_dups
setopt hist_ignore_space
setopt nobeep
setopt hist_ignore_dups
# setopt share_history
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

######################################
# env
######################################
# for homebrew
export PATH=/usr/local/bin:~/.bin:$PATH
# for python
export PYTHONSTARTUP=~/.pythonstartup
export VIRTUALENV_USE_DISTRIBUTE=1
# for terminal color
export TERM=xterm-256color
# for grep
if [ `uname` = 'Darwin' ]; then
  export GREP_OPTIONS='--color=always'
  export GREP_COLOR='1;35;40'
fi
# for vim
export UPDATE_DOTFILES_DAYS=13
source ~/.dotfiles/check_for_upgrade.sh
# for zsh
export UPDATE_ZSH_DAYS=13
export ZSHDOT=~/.zsh
export ZSH=$ZSHDOT/oh-my-zsh
DISABLE_AUTO_TITLE='true'
plugins=(git gnu-utils z vi-mode python history web-search)
source $ZSH/oh-my-zsh.sh
# ZSH_THEME="robbyrussell"
source $ZSHDOT/zsh-theme/theme.zsh
# other options
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_CTYPE='en_US.UTF-8'
export EDITOR=vim
export SSH_KEY_PATH="~/.ssh/id_rsa"
export GITHUB_USER="wkentaro"
source $ZSHDOT/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

##################################
# bindkey
##################################
function percol-history() {
  LBUFFER=$(fc -l 1 | tac | percol | sed -r "s/^ *[0-9]*(\*)? *//g")
  zle -R -c
}
zle -N percol-history
bindkey '^R' percol-history
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^F" forward-char
bindkey "^B" backward-char
bindkey "^D" delete-char
bindkey "^K" kill-line
bindkey "^Y" yank

##################################
# alias
##################################
source ~/.shrc.alias
# copy
if which pbcopy >/dev/null 2>&1 ; then 
  alias -g C='| pbcopy' # mac
elif which xsel >/dev/null 2>&1 ; then 
  alias -g C='| xsel --input --clipboard' # ubuntu
elif which putclip >/dev/null 2>&1 ; then 
  alias -g C='| putclip' # cygwin
fi
function _zcd ()
{
  if [ "$1" = "" ]; then
    dir=$(_z 2>&1 | sed -E "s/^([0-9]|\.)* *//g" | tac | percol)
  else
    dir=$1
  fi
  if [ "$dir" != "" ]; then
    _z $dir
  fi
}
alias z='_zcd'
if [ `uname` = 'Linux' ]; then
  source $ZSHDOT/zshrc.linux
fi
source $ZSHDOT/utils.zsh