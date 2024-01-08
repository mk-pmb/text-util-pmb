#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function cal_parseable () {
  local FUNC="${FUNCNAME}__$1"
  if [ "$(type -t "$FUNC")" == function ]; then
    shift
    "$FUNC" "$@"
    return $?
  fi
  LANG=C ncal -Mbh "$@" | sed -nrf <(echo '
    : any
      s~(.{20})  ~\1 ## ~g
      /^ +## +[0-9]+[ #]*$/b yearline
      /^ {3,}[A-Z]/b monthline
      /^[A-Z]|^[ #]*([0-9]|$)/b weekline
      s~^~?? ~
    : copy
      p;n
    b any

    : yearline
      s~[ #]~~g
      N
      s~\n~    &~
      s~^([0-9][0-9 ]{3}) *\n~<\1>~
    : add_year_to_month
      s~<([0-9 ]+)> {3}( +[A-Z][a-z]+ ) {2}~\2\1 <\1>~
      s~<[0-9 ]+>( *)$~\1~
    t add_year_to_month
    b any

    : monthline
      s~(^|## )( *)([A-Z][a-z]* [0-9]* *)~\1: == : \3\2  : == : ~g
      s~[# ]+$~~
    b copy

    : weekline
      s~.{3}~: &~g
      s~[# ]+$~~
      s~: {4}~:  _ ~g
    b copy
    ')
  return ${PIPESTATUS[0]}
}


function cal_parseable__tsv_months () {
  local YEAR="$1"; shift
  local MONTH="$1"; shift
  local PLUS="$1"; shift
  if [ -z "$MONTH" ]; then
    PLUS="$YEAR"
    printf -v YEAR '%(%Y)T' -1
    printf -v MONTH '%(%m)T' -1
  fi
  MONTH="${MONTH#0}"
  while [ "${PLUS:-0}" -ge 0 ]; do
    let PLUS="$PLUS-1"
    printf '%04g-%02g-01\n' "$YEAR" "$MONTH"
    ncal -Mbh -m "$MONTH" "$YEAR" | sed -rf <(echo '
      1d # skip month line
      s~(.{3})~\t\1~g
      s~\t {3}~\t_~g
      s~ ~~g
      ')
    echo
    let MONTH="$MONTH+1"
    if [ "$MONTH" -gt 12 ]; then
      let MONTH="$MONTH-12"
      let YEAR="$YEAR+1"
    fi
  done
}






















[ "$1" == --lib ] && return 0; cal_parseable "$@"; exit $?
