#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
#
# This script is meant to run in a pipe chain after `jq`,
# receive the indented output, and collapse some of that whitespace.

export LANG=C # <- important for sed properly matching character ranges

# Mark the inner borders of container contents:
sed -zre 's~(\{|\[)\n +~&\f~g; s~\n *(\]|\})~\v&~g' |
# Condense tail of single-item containers:
sed -re '/\v$/!b; /\f/!b; N; s~\v\n *~ ~' | tr -d '\f\v' |
# The front will be condensed by a later rule that applies to
# all containers independent of contents.

sed -zre 's~(\{|\[)\n\s*(["-Z_-z])~\1 \2~g'
