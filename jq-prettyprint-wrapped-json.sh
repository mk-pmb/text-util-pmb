#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
export LANG=C
grep --line-buffered . | # <- ensure a final newline character
while IFS= read -r BUF; do
  SUF=
  case "$BUF" in
    *'{'*'"'*'"'*:*'}'* )
      echo -n "${BUF%%'{'*}"
      BUF="{${BUF#*'{'}"
      SUF="${BUF##*'}'}"
      BUF="${BUF%'}'*}}"
      PRETTY="$(echo "$BUF" | jq 2>/dev/null)"
      [ "${PRETTY:0:1}" != '{' ] || BUF="$PRETTY"
      ;;
  esac
  echo "$BUF$SUF"
done

# Consider piping the result into `jq-slightly-condense-whitespace`
# if the next step in your workflow can use that.
