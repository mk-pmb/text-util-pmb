#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
sed -rf <("$SELFPATH"/sed-flip-simple-global-literal-replacements.sed \
  "$SELFPATH"/ueml.html.sed) "$@"; exit $?
