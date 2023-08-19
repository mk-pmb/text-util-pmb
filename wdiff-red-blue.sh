#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
exec wdiff \
  --start-delete=$'\x1B[91m' \
  --start-insert=$'\x1B[94m' \
  --end-{delete,insert}=$'\x1B[0m' \
  "$@"; exit $?
