#!/bin/sed -rf
# -*- coding: UTF-8, tab-width: 2 -*-
s~Ä~Ae~g; s~Ö~Oe~g; s~Ü~Ue~g
s~ä~ae~g; s~ö~oe~g; s~ü~ue~g
s~ß~sz~g

# Latin-1
s~\xC4~Ae~g; s~\xD6~Oe~g; s~\xDC~Ue~g
s~\xE4~ae~g; s~\xF6~oe~g; s~\xFC~ue~g
s~\xDF~sz~g
