#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
exec -a "$0" xargs -d $'\n' -- "$@"; exit $?
