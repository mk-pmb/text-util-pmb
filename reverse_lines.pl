#!/usr/bin/perl

use strict;

$| = 1;  # disable output buffering (tribute to perl 5.8.x)

chomp(my @zeilen = <STDIN>);
while (@zeilen > 0) { print pop(@zeilen), "\n"; }
