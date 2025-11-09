#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function moneysum_cli_init () {
  # args: Optional options, then optional amounts.
  # stdin: One amount per line.
  #
  # Optional options:
  #   * Number format in quick notation, i.e. thousands separator,
  #     decimal separator, fraction length as single digit.
  #     Related env vars: MONEYSUM_THSD_SEP MONEYSUM_FRAC_SEP MONEYSUM_FRAC_LEN
  #   * (`<<` or `>>`) + any text: Decorations for the result line.
  #     The result line has a "head" (printed in front of the amount) and a
  #     "tail" (printed after the amount), default: both empty.
  #     Your decoration option text will be appended to the head (`<<`)
  #     or tail (`>>`). Related env vars: MONEYSUM_HEAD MONEYSUM_TAIL
  #
  # To sum the last column of a German statement of account:
  # grep -oPe '[\t;] *[+-]?[\d\.,]+$' -- umsaetze.csv |
  #   moneysum-args-and-stdin .,2 '<<∑ = ' '>> €'

  local THSD_SEP="${MONEYSUM_THSD_SEP:-,}"
  local FRAC_SEP="${MONEYSUM_FRAC_SEP:-.}"
  local FRAC_LEN="${MONEYSUM_FRAC_LEN:-2}"
  local HEAD="$MONEYSUM_HEAD"
  local TAIL="$MONEYSUM_TAIL"

  while [ -n "$1" ]; do case "$1" in
    '<<'* ) HEAD+="${1:2}"; shift;;
    '>>'* ) TAIL+="${1:2}"; shift;;
    [^A-Za-z0-9][^A-Za-z0-9][0-9] )
      # Accepting only a single digit for precision in quick config seems
      # to be a good trade-off between easy configuration and reliable
      # input validation: If the first argument was meant as a number,
      # it would violate the default configuration in at least three ways
      # (two empty number groups + fraction too short).
      THSD_SEP="${1:0:1}"
      FRAC_SEP="${1:1:1}"
      FRAC_LEN="${1:2}"
      shift;;
    * ) break;;
  esac; done

  local PAD_R=
  case "$FRAC_LEN" in
    '' ) echo E: $FUNCNAME: 'Exotic control flow error' >&2; return 4;;
    0 ) ;;
    [1-9] | [1-9][0-9] ) printf -v PAD_R -- '%0*d' "$FRAC_LEN" 0;;
    * )
      echo E: $FUNCNAME: 'Fraction length must an integer in range 0..99!' >&2
      return 4;;
  esac

  local SUM="$THSD_SEP$FRAC_SEP"
  [ "${SUM//[A-Za-z0-9]/}" == "$SUM" ] || return 4$(echo E: $FUNCNAME: >&2 \
    'Thousands separator and decimal separator must not be alphanumeric!')
  # … because we want to unconditionally backslash-escape it in the regexps.
  # We can't take a regexp because then we'd need a plain version for the
  # result output.

  local DBGLV="${DEBUGLEVEL:-0}"
  local SED='
    s!^\s+!!
    s!^[0-9]!+&!
    s!\s+$!!
    /\'"$FRAC_SEP"'/!s!$!'"$PAD_R"'!
    s!\'"$FRAC_SEP"'([0-9]{'"$FRAC_LEN"'})$!\1!
    s~\'"$THSD_SEP"'~~g
    s!^([+-])0*!\1!
    /^[+-]$/d
    '
  local SUM=0
  [ "$#" == 0 ] || SUM+="$(printf -- '%s\n' "$@" | sed -re "$SED")"
  let SUM="${SUM//$'\n'/}"
  sed -ure "$SED" | moneysum_rolling_sum
}


function moneysum_rolling_sum () {
  local SUM="${SUM:-0}" LN=
  while IFS= read -r LN; do
    [ "$DBGLV" -lt 2 ] || echo -n D: $FUNCNAME: "'$SUM''$LN' = "  >&2
    let SUM="$SUM$LN"
    [ "$DBGLV" -lt 2 ] || echo "'$SUM'"  >&2
  done
  local SIGN="${SUM:0:1}"
  [ "$SIGN" == - ] || SIGN=+
  SUM="${SUM#-}"
  while [ "${#SUM}" -le "$FRAC_LEN" ]; do SUM="0$SUM"; done
  [ "$DBGLV" -lt 2 ] || echo -n "padded: $SUM, " >&2
  local REV= # digits in reverse order
  while [ -n "$SUM" ]; do
    REV="${SUM:0:1}$REV"
    SUM="${SUM:1}"
  done
  [ "$DBGLV" -lt 2 ] || echo -n "reverse digits: [${REV% }]" >&2
  SUM=
  while [ "${#SUM}" -lt "$FRAC_LEN" ]; do
    SUM="${REV:0:1}$SUM"
    REV="${REV:1}"
  done
  SUM="$FRAC_SEP$SUM"
  local THSD_LEN=0
  while [ -n "$REV" ]; do
    [ "$THSD_LEN" -lt 3 ] || SUM="$THSD_SEP$SUM"
    SUM="${REV:0:1}$SUM"
    REV="${REV:1}"
    (( THSD_LEN = ( THSD_LEN % 3 ) + 1 ))
  done
  echo "$HEAD$SIGN$SUM$TAIL"
}


moneysum_cli_init "$@"; exit $?
