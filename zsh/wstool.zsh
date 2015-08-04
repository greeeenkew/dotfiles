#!/usr/bin/env zsh

wstool_info () {
  local repo target_ws
  local -a options
  for arg in ${@}; do
    if [ "${arg:0:1}" = "-" ]; then
      options=($options $arg)
    elif [ "${options[-1]}" = "-t" -o \
           "${options[-1]}" = "--target-workspace" ]; then
      options=($options $arg)
    elif [ "$repo" = "" ]; then
      repo=$arg
    fi
  done
  if [ "$repo" != "" ]; then
    local -a repos
    repos=( $(command wstool info --only=localname | grep $repo) )
    command wstool info $repos $options
  else
    command wstool info $@
  fi
}

wstool_update () {
  local repo
  local -a options
  for arg in ${@}; do
    if [ "${arg:0:1}" = "-" ]; then
      options=($options $arg)
    elif [ "$repo" = "" ]; then
      repo=$arg
    fi
  done
  if [ "$repo" != "" ]; then
    local -a repos
    repos=( $(command wstool info --only=localname | grep $repo) )
    command wstool update $repos $options
  else
    command wstool update $@
  fi
}

wstool_set () {
  local repo uri
  local -a options
  for arg in ${@}; do
    if [ "${arg:0:1}" = "-" ]; then
      options=($options $arg)
    elif [ "$repo" = "" ]; then
      repo=$arg
    elif [ "$uri" = "" ]; then
      uri=$arg
    fi
  done
  # resolve args
  if echo $uri | egrep -q "\.git$"; then
    [ "${options[(r)--git]}" = --git ] || options=($options --git)
  fi
  if [ "${options[(r)--hub]}" = "--hub" ]; then
    echo $uri | egrep -q "^https?://" || {
      if [ "${options[(r)--ssh]}" = --ssh ]; then
        uri="git@github.com:$uri.git"
        options[$options[(i)--ssh]]=()
      else
        uri="https://github.com/$uri.git"
      fi
    }
    [ "${options[(r)--git]}" = --git ] || options=($options --git)
    options[$options[(i)--hub]]=()
  fi
  if [ "$uri" != "" ]; then
    command wstool set $repo $uri $options
  else
    command wstool set $@
  fi
}

wstool () {
  case "$1" in
    (update|up)
      shift; wstool_update $@
      ;;
    (set)
      shift; wstool_set $@
      ;;
    (info)
      shift; wstool_info $@
      ;;
    (*)
      command wstool $@
      ;;
  esac
}
