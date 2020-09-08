#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dict_search_all () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local GLUED="$(printf '%s\n' "$@")"
  [ -n "$GLUED" ] || GLUED="$(clipdump)"
  GLUED="$(<<<"$GLUED" grep -Pe '\S' | sort --unique)"
  [ -n "$GLUED" ] || return 3$(
    echo "E: $FUNCNAME: Found no words in CLI args and clipboard." >&2)
  cd /usr/share/dict || return $?
  local DICTS=(
    -mindepth 1
    -maxdepth 1
    -name '[a-z]*'
    -not -name '*.*'
    -printf '%f\n'
    )
  readarray -t DICTS < <(find "${DICTS[@]}" | LANG=C sort)
  [ -n "${DICTS[*]}" ] || return 8$(
    echo "E: $FUNCNAME: Found no dictionaries. That's odd." >&2)
  local ALL_MATCHES="$(grep -nFie "$GLUED" -- "${DICTS[@]}" | sed -rf <(echo '
    s~\a~~g
    s~(:[0-9]+):~\1\t\a~
    s~$~\a\t~
    '))"
  [ -n "$ALL_MATCHES" ] || return 4$(
    echo "E: none of the input words were found in any dictionary." >&2)
  local WORDS=()
  readarray -t WORDS <<<"$GLUED"
  local WORD= MATCH=
  for WORD in "${WORDS[@]}"; do
    printf '%s\t' "$WORD"
    MATCH="$(<<<"$ALL_MATCHES" grep -Fie $'\t\a'"$WORD"$'\a\t' | cut -sf 1)"
    if [ -n "$MATCH" ]; then
      echo $'exact\t'"${MATCH//$'\n'/, }"
      continue
    fi
    MATCH="$(<<<"$ALL_MATCHES" grep -Fie $'\t\a'"$WORD")"
    if [ -n "$MATCH" ]; then
      echo -n $'prefix\t'
      MATCH="$(<<<"$MATCH" sed -rf <(echo '
        '))"
      MATCH="${MATCH//$'\t\a'"$WORD"/$'\t…'}"
      MATCH="${MATCH//$'\a'/}"
      MATCH="${MATCH//$'\n'/$'\n'"$WORD"$'\tprefix\t'}"
      echo "$MATCH"
      continue
    fi
    echo 'none'
  done
}




dict_search_all "$@"; exit $?
