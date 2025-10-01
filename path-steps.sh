#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function path_steps () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local TODO= HAD= KEEP= STEP=
  for TODO in "$@"; do
    HAD=
    while [ -n "$TODO" ]; do
      STEP="${TODO%%/*}"
      echo "$HAD$STEP"
      STEP+="${TODO:${#STEP}:1}" # <-- either / or empty
      HAD+="$STEP"
      TODO="${TODO:${#STEP}}"
    done
  done
}










path_steps "$@"; exit $?
