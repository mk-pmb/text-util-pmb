#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function verify_trailing_nums_subtotals () {
  echo "W: pre-alpha!" >&2
  LANG=C sed -nurf <(echo '
    s~\s(\+|\-|=|)\s*([0-9,.]+)~\n\1: \2~
    /\n/{
      /[0-9]$/!d
      s~^.*\n~~
      s!^:!+:!
      s~:~~
      s~\s~~g
      =
      p
    }
    ') -- "$@" | LANG=C sed -nurf <(echo '
    N;s~\n~ ~
    p
    ')
  echo "W: pre-alpha!" >&2
  return 8
}










verify_trailing_nums_subtotals "$@"; exit $?
