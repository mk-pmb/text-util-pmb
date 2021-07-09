#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function colorbox_msg () {
  local COLORS="$1"; shift
  local DECO="$1"; shift
  local MSG="$*"
  local BOX_WIDTH=75
  local BAR_LINE="$(yes "$DECO" | head -n "$BOX_WIDTH" | tr -d '\n')"
  if [ "${DECO% }" == "$DECO" ]; then
    BAR_LINE="${BAR_LINE:0:$BOX_WIDTH}"
  else
    DECO="${DECO% }"
    BAR_LINE="$(<<<"$BAR_LINE" grep -oPe '^.{'"$BOX_WIDTH"'}\S*' -m 1)"
  fi
  BOX_WIDTH="${#BAR_LINE}"

  local PAD_W=
  let PAD_W="$BOX_WIDTH - (2 * ${#DECO}) - 2"
  local PAD_L=
  let PAD_L="($PAD_W - ${#MSG}) / 2"
  local PAD_R=
  let PAD_R="($PAD_W - ${#MSG}) - $PAD_L"

  COLORS="$(printf '\x1b[%sm' "$COLORS")"
  local CRESET="$(printf '\x1b[%sm' 0)"
  BAR_LINE="${COLORS}${BAR_LINE}${CRESET}"

  PAD_L="$(printf "%s%s% ${PAD_L}s:" "$COLORS" "$DECO" '')"
  PAD_L="${PAD_L%:}"
  PAD_R="$(printf "% ${PAD_R}s%s%s" '' "$DECO" "$CRESET")"
  local SEP_LINE="$(printf "%s%s % ${PAD_W}s %s%s" \
    "$COLORS" "$DECO" '' "$DECO" "$CRESET")"

  echo "$BAR_LINE"
  #echo "$SEP_LINE"
  echo "$PAD_L $MSG $PAD_R"
  #echo "$SEP_LINE"
  echo "$BAR_LINE"

  return 0
}











[ "$1" == --lib ] || colorbox_msg "$@" || exit $?
