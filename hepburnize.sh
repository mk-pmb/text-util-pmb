#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function hepburnize () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  if [ "$1" == --demo ]; then
    shift
    exec <<<'大部分が温帯に属するが、北部や島嶼部では亜寒帯や熱帯の地域がある。'
    # ^-- From https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC (nippon)
    #     "Most of it belongs to the temperate zone, but there are subarctic
    #     and tropical regions in the northern and island parts."
  fi
  local CONV=(
    kakasi
    -w          # add spaces between words.
    -rhepburn   # use Hepburn romanization
    -{i,o}utf8  # Use UTF-8 input and output
    -u    # flush output
    -Ja   # Kanji -> ascii
    -ga   # DEC graphic -> ascii
    -Ha   # Hiragana -> ascii
    -ka   # Katakana (JIS x0201) -> ascii
    -Ka   # Katakana (JIS x0208) -> ascii
    -Ea   # Sign -> ascii
    -f    # Furigana (annotate original word); for Kanji missing in
          # the dictionary, this provides at least pronunciation.
    )
  tty --silent && echo "D: Reading japanese text from stdin." >&2
  "${CONV[@]}" "$@" || return $?
}










hepburnize "$@"; exit $?
