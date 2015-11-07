# vim: set ft=sh:

# basic
alias sudo='sudo '
alias cl='clear'
alias lv='less'

# date
alias date1='date +"%Y-%m-%d"'
alias date2='date +"%Y%m%d-%H%M%S"'

# mv
alias mvi='mv -i'

# rm
alias rmi='rm -i'

# open
type gnome-open &>/dev/null && alias open=gnome-open
alias o='open'
alias o.='open .'

# browsing
alias gcal='open https://www.google.com/calendar/render#g >/dev/null 2>&1'
alias gmail='open https://mail.google.com/mail/u/0/ >/dev/null 2>&1'

# vim
type vim &>/dev/null && {
  alias v='vim'
  alias vi='vim'
  alias vii='vim --noplugin'
  alias viii='vim -u NONE'
}
type nvim &>/dev/null && {
  alias n='nvim'
  alias nvi='nvim'
  alias nvii='nvim --noplugin'
  alias nviii='nvim -u NONE'
}
alias vim-bib='vim -c ":e ++enc=euc-jp"'

# emacs
alias emacs='emacs -nw'

# python
alias py='python'
alias ipy='ipython'
alias ipp='ptipython'

# ruby
alias irb='irb --simple-prompt'

# cmatrix
alias matrix='cmatrix -sb'

# tmux
alias t='tmux'
alias tls='tmux ls'
alias ta='tmux attach'
alias tat='tmux attach -t'
alias tn='tmux new'
alias tns='tmux new -s'

# gifify
gifify () {
  docker run -it --rm -v `pwd`:/data maxogden/gifify $@
}

# wstool
alias wl=wstool
alias wli='wstool info'
alias wlcd='wstool_cd'
alias wlset='wstool set'
alias wlup='wstool update'

# brew
if type brew &>/dev/null; then
  alias bubu='brew update && brew upgrade && brew cleanup'
  alias bububu='bubu && brew cask update && brew cask cleanup'
fi

# ----------------------------------------------------
# pandoc
# ----------------------------------------------------
md2rst () {
  pandoc --from=markdown --to=rst $1
}
rst2md () {
  pandoc --from=rst --to=markdown $1
}

# ----------------------------------------------------
# wrapping with rlwrap
# ----------------------------------------------------
if type rlwrap &>/dev/null; then
  alias eus='rlwrap eus'
  alias irteusgl='rlwrap irteusgl'
  alias irb='rlwrap irb'
  alias clisp="rlwrap -b '(){}[],#\";| ' clisp"
  if [ "$EMACS" = "" ]; then
    alias roseus="rlwrap -c -b '(){}.,;|' -a -pGREEN roseus"
  fi
fi

# ----------------------------------------------------
# ROS
# ----------------------------------------------------
if [ -d "/opt/ros" ]; then
  alias rp='rostopic'
  alias rpl='rostopic list'
  alias rpi='rostopic info'
  alias rn='rosnode'
  alias rnl='rosnode list'
  alias rni='rosnode info'
  alias rs='rosservice'
  alias rsl='rosservice list'
  alias rl='roslaunch'
  alias rqt_gui='rosrun rqt_gui rqt_gui'
  alias rqt_reconfigure='rosrun rqt_reconfigure rqt_reconfigure'
  alias rqt_image_view='rosrun rqt_image_view rqt_image_view'
  image_view () {
    rosrun image_view image_view image:=$1
  }
  rosrecord () {
    if rostopic list &>/dev/null; then
      local topics timestamp
      timestamp=$(date +%Y-%m-%d-%H-%M-%S)
      mkdir -p $timestamp
      echo "Recording to $timestamp"
      cd $timestamp
      rosparam dump "${timestamp}_rosparam.yaml"
      rosbag record $(rostopic list | percol | xargs) --output-name=$timestamp --size=2000 --split --buffsize=0
      cd ..
    else
      return 1
    fi
  }
fi

alias wllist='wstool info --only=localname'
wlsethub () {
  wstool set $1 https://github.com/$1.git --git
}

# ----------------------------------------------------
# ls aliases
# ----------------------------------------------------
alias sl='ls'
if type dircolors &>/dev/null; then
  [ -f $HOME/.dircolors.256dark ] && eval $(dircolors $HOME/.dircolors.256dark 2>/dev/null)
fi
if ls --color &>/dev/null; then
  # GNU ls
  if [ $TERM = "dumb" ]; then
    # Disable colors in GVim
    alias ls='ls -F --show-control-chars'
    alias la='ls -ahF --show-control-chars'
    alias ll='ls -lhF --show-control-chars'
    alias lsa='ls -lahF --show-control-chars'
  else
    # Color settings for zsh complete candidates
    alias ls='ls -F --show-control-chars --color=always'
    alias la='ls -ahF --show-control-chars --color=always'
    alias ll='ls -lhF --show-control-chars --color=always'
    alias lsa='ls -lahF --show-control-chars --color=always'
  fi
else
  # Darwin ls
  alias ls='ls -FG'
  alias la='ls -ahFG'
  alias ll='ls -lhFG'
  alias lsa='ls -lahFG'
  export CLICOLOR=1
  export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

convert_to_gif () {
  if which ffmpeg &>/dev/null; then
    ffmpeg -i $1 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3
  elif which avconv &>/dev/null; then
    avconv -i $1 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3
  fi
}

get_lena_jpg () {
  wget https://jviolajones.googlecode.com/files/lena.jpg
}
tile_images() {
  montage $@ -geometry +2+2 $(date +%Y%m%d-%H%M%S)_output.jpg
}
