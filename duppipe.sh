#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
# demo: ls /usr | duppipe tr aeiouAEIOU _ | nl -ba
(tee /dev/stderr | "$@") 2>&1
exit $?
