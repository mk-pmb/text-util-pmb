#!/usr/bin/python
# -*- coding: UTF-8, tab-width: 4 -*-

from sys import stdin

prev = None

for line in stdin:
    line = line.rstrip()
    if prev is not None:
        diff = ''
        maxlen = len(line)
        if maxlen < len(prev):
            maxlen = len(prev)
        for idx in xrange(maxlen):
            if idx >= len(prev):
                diff += '.'
            elif idx >= len(line):
                diff += "'"
            elif line[idx] == prev[idx]:
                diff += ' '
            else:
                diff += '|'
        print diff
    print line
    prev = line
