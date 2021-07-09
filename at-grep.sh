#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function at_grep () {
  local AT_SEP='\t@ '
  local LN_SEP=':'
  while true; do
    case "$1" in
      -@ ) shift; AT_SEP="$1";;
      -: ) shift; LN_SEP="$1";;
      * ) break;;
    esac
    shift
  done
  local IN_CMD=( grep -n )
  if [ "$1" == -- ]; then
    # no expression (-e) yet => can't grep
    #   => input probably is grep-ped already
    shift
    IN_CMD=( cat )
  fi
  "${IN_CMD[@]}" "$@" | sed -re '
    s`^([^:]*[^:0-9][^:]*):([0-9]+):(.*)$`\3'"$AT_SEP\1$LN_SEP"'\2`'
  local RV="${PIPESTATUS[*]}"
  let RV="${RV// /+}"
  return "$RV"
}


[ "$1" == --lib ] && return 0; at_grep "$@"; exit $?
