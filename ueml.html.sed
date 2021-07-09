#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-
s~Ä~\&Auml;~g; s~Ö~\&Ouml;~g; s~Ü~\&Uuml;~g
s~ä~\&auml;~g; s~ö~\&ouml;~g; s~ü~\&uuml;~g
s~ß~\&szlig;~g

# Latin-1
s~\xC4~\&Auml;~g; s~\xD6~\&Ouml;~g; s~\xDC~\&Uuml;~g
s~\xE4~\&auml;~g; s~\xF6~\&ouml;~g; s~\xFC~\&uuml;~g
s~\xDF~\&szlig;~g
