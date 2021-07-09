#!/usr/bin/perl
#
#   Copyright (C) 2006 Marcel Krause <marcel_k@web.de>
#
#
#   This file is part of Transposer.
#
#   Transposer is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   Transposer is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Transposer; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#   or download it from http://www.gnu.org/copyleft/gpl.html .
#

use strict;
use IO::File;

$| = 1;  # disable output buffering (tribute to perl 5.8.x)

my $infh = \*STDIN;
my $outfh = \*STDOUT;
our $errfh = \*STDERR;

my $input_cellsep = "\t";
my $output_cellsep = $input_cellsep;

my @args = @ARGV;
while (@args > 0)
{
  my $arg = shift @args;

  if ($arg eq '-i') { &reopen(\$infh, shift @args, '<'); }
  if ($arg eq '-o') { &reopen(\$outfh, shift @args, '>'); }
  if ($arg eq '-O') { &reopen(\$outfh, shift @args, '>>'); }
  if ($arg eq '-e') { &reopen(\$errfh, shift @args, '>'); }
  if ($arg eq '-E') { &reopen(\$errfh, shift @args, '>>'); }

  if ($arg eq '-s') { $input_cellsep = shift @args; }
  if ($arg eq '-S') { $output_cellsep = shift @args; }

  if (($arg eq '--help') or ($arg eq '-h')) { &help; }
}

my @matrix = ();
my $orig_width = 0;
my $orig_height = 0;

my $cellsep_re = quotemeta $input_cellsep;

while(my $row = <$infh>)
{
  chomp($row);
  $orig_height++;
  my @cells = split /$cellsep_re/, $row;
  if ($orig_width < @cells) { $orig_width = @cells; }
  push @matrix, \@cells;
}

for my $trans_row (1..$orig_width)
{
  for my $trans_col (1..$orig_height)
  {
    if ($trans_col > 1) { print $outfh $output_cellsep; }
    print $outfh $matrix[$trans_col - 1]->[$trans_row - 1];
  }
  print $outfh "\n";
}

sub reopen
{
  my ($fhref, $fn, $modus) = @_;

  my $fh_neu = new IO::File;
  if (open($fh_neu, $modus, $fn))
  {
    $$fhref = $fh_neu;
    return $fh_neu;
  }
  else
  {
    print $errfh "cannot open file '$fn': $!\n";
    return $!;
  }
}


sub help
{
  print join "\n", '',
    "Transposer   (C) 2006 Marcel Krause <marcel_k\@web.de>",
    '',
    'Syntax: transpose [-ioO <file>] [-sS <text>]',
    '',
    "  -i    read from <file> (not from STDIN)",
    "  -o    write to <file> (not to STDOUT), replacing file",
    "  -O    write to <file> (not to STDOUT), appending to file",
    '',
    "  -s    use <text> as cell separator for input",
    "  -S    use <text> as cell separator for output",
    '',
    '';
  exit 0;
}
