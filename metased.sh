#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function metased () {
  local RUNMODE="$1"; shift
  local SCRIPT_FN="$1"; shift

  local SED_FLAGS=urf
  local RGX='^-[ur]*(n|)[ur]*f$'
  [[ "$RUNMODE" =~ $RGX ]] && RUNMODE="-${BASH_REMATCH[1]:--}"

  case "$RUNMODE" in
    -- ) ;;
    --rules | --transform )
      metased__transform "$SCRIPT_FN"
      return $?;;
    --meta-rules )
      metased__meta_cmd "$SCRIPT_FN"
      return $?;;
    -n | --noprint ) SED_FLAGS="n$SED_FLAGS";;
    --diff )
      SCRIPT_FN="$1"; shift
      diff -sU 2 "$SCRIPT_FN" <(metased__transform "$SCRIPT_FN")
      return $?;;
    --help | \
    -* )
      local -fp "${FUNCNAME[0]}" | guess_bash_script_config_opts-pmb \
        --optvar=RUNMODE --avail=runmodes --dashes=
      [ "${RUNMODE//-/}" == help ] && return 0
      echo "E: $0: unsupported runmode: $RUNMODE" >&2; return 1;;
    * ) set -- "$SCRIPT_FN" "$@"; SCRIPT_FN="$RUNMODE"; RUNMODE=;;
  esac
  sed -"$SED_FLAGS" <(metased__transform "$SCRIPT_FN") "$@"
  return $?
}


function metased__meta_cmd () {
  local SCRIPT_FN="$1"; shift
  local SCRIPT_DIR="$(dirname "$(readlink -m "$SCRIPT_FN")")"
  nl -ba "$SCRIPT_FN" | sed -nre '
    # ^< include.sed = read include.sed
    s~^\s*([0-9]+)\t(\s*)\^\s*<\s*(\S+)$~\1{\
        s|^(\\s*)\\^\\s*<\\s*(\\S+)\s*$|\\1#>>> \\2 >>>#|\
        r '"$SCRIPT_DIR"'/\3\
        a\\\2#<<< \3 <<<#\
        }~p
    s~^ *([0-9]+)\t(\s*)\^~\2~p
    : line_done
  '
}


function metased__transform () {
  local SCRIPT_FN="$1"; shift
  local META_RV=
  sed -rf <(metased__meta_cmd "$SCRIPT_FN"
    ) -e 's~^(\s*)(\^)~\1#\2~' "$SCRIPT_FN"
  META_RV=$?
  if [ "$META_RV" != 0 ]; then
    sleep 0.2s  # wait for possible other piped seds to display their errors.
    echo "b metased_error@$SCRIPT_FN"
  fi
  return "$META_RV"
}











[ "$1" == --lib ] || metased "$@" || exit $?
