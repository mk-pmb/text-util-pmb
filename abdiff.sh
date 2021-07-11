#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function abdiffuse () {
  cd /
  local SIDES=( "$(mk_tmp a)" "$(mk_tmp b)" )
  local VDIFF="$(
    which \
      diffuse \
      meld \
      2>/dev/null | grep -m 1 -Pe '^/'
    )"
  ( "$VDIFF" "${SIDES[@]}"; rm -- "${SIDES[@]}" ) &
  disown $!
  return 0
}


function mk_tmp () {
  local SIDE="$1"
  mktemp --tmpdir="$HOME"/.cache/ abdiff.XXXXXXXXXX."$SIDE".txt
  return $?
}








[ "$1" == --lib ] && return 0; abdiffuse "$@"; exit $?
