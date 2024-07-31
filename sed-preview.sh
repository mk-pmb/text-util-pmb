#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
SRC="$1"; shift; colordiff -sU 2 "$SRC" <(sed -r "$@" -- "$SRC"); exit $?
