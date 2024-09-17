#!/bin/sed -zrf
# -*- coding: UTF-8, tab-width: 2 -*-
#
# "simple global literal replacements" means a sed script with just static
# `s~…~…~g` expressions where both `…` parts are literal strings,
# like `in ueml.html.sed`. This script flips them around.

: split
  s!(\ns\S+); !\1\n!g
t split
s!\~!\v&\v!g
s!(\ns)(\v\S+\v\S+)(\v\S+\v\S+)(\v\S+\vg)!\1\3\2\4!g
s!\v!!g
