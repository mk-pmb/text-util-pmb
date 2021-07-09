#!/usr/bin/perl
# -*- coding: UTF-8, tab-width: 2 -*-
use strict;

open (CLIP, 'pclip |') || die "Cannot read clipboard content: $!";
my $text = join '', <CLIP>;
close CLIP;

$text =~ s!\r!!og;
$text =~ s![^\S\n]+\n!\n!og;
$text =~ s!\n[^\S\n]+!\n!og;
$text =~ s!\n{3,}!\n\n!og;

# potentielle Verknüpfungsstellen markieren
$text =~ s!([^\n])\n([^\n])!$1\r$2!og;

# entferne Markierung wieder, wenn Aufzählung folgt:
$text =~ s!\r(\(?\d+\) |\d+\. |[a-z] )!\n$1!iog;

# wandle restliche Markierungen in Space um:
$text =~ s!\r! !og;

open (CLIP, '| gclip') || die "Cannot write clipboard content: $!";
print CLIP $text;
close CLIP;
