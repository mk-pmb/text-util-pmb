#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function trcut () {
  local IN_SEPS="$1"; shift
  local OUT_FIELDS="$1"; shift
  [ -n "$IN_SEPS" ] || IN_SEPS='\s'
  [ "${IN_SEPS:0:2}" == '\s' ] && IN_SEPS="\t \r${IN_SEPS#\\s}"
  local OUT_SEP="${IN_SEPS:0:1}"
  if [ "$OUT_SEP" == '\' ]; then
    OUT_SEP="$(<<<: tr : "${IN_SEPS:0:2}"; echo :)"
    OUT_SEP="${OUT_SEP:0:1}"
  fi
  cat "$@" | tr -s "$IN_SEPS" "$OUT_SEP" | cut -d "$OUT_SEP" -sf "$OUT_FIELDS"
  local RV="${PIPESTATUS[*]}"
  let RV="${RV// /+}"
  return "$RV"
}


[ "$1" == --lib ] && return 0; trcut "$@"; exit $?
