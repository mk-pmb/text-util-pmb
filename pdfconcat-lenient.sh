#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function pdfconcat_lenient () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local DEST_FILE=
  case "$1" in
    -o ) shift; DEST_FILE="$1"; shift;;
    * )
      echo E: "First two arguments must be '-o' and an output filename." >&2
      return 4;;
  esac
  case "$DEST_FILE" in
    '' ) echo E: 'Destination filename must not be empty.' >&2; return 4;;
    /* | ./* | ../* | [A-Za-z0-9_]*.pdf ) ;;
    * ) DEST_FILE="./$DEST_FILE";;
  esac
  [ ! -e "$DEST_FILE" ] || [ ! -s "$DEST_FILE" ] || return 4$(
    echo E: "Flinching from overwriting non-empty destination: $DEST_FILE" >&2)

  local INPUT_FILENAMES=()
  local VAL=
  for VAL in "$@"; do
    case "$VAL" in
      /* | ./* | ../* | [A-Za-z0-9_]*.pdf ) INPUT_FILENAMES+=( "$VAL" );;
      * ) INPUT_FILENAMES+=( "./$VAL" );;
    esac
  done

  # * pdftk can deal with inputs where pdfconcat would fail with e.g.
  #   * `pdfconcat: error at input.pdf:5802: trailer expected`
  pdftk "${INPUT_FILENAMES[@]}" cat output "$DEST_FILE" || return $?$(
    echo E: "pdftk failed, rv=$?" >&2)
}










[ "$1" == --lib ] && return 0; pdfconcat_lenient "$@"; exit $?
