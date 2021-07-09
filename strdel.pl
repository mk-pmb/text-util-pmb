#!/usr/bin/perl

# strdel - delete substring from input line

use strict;

$| = 1;  # disable output buffering (tribute to perl 5.8.x)

my @regexps = ();
my $default_case_sens = 0;
my $default_plain_text = 1;
my $default_leading_only = 0;
my $default_trailing_only = 0;

my @args = @ARGV;
while(@args > 0)
{
  my $arg = shift @args;

  if ($arg eq '+cs') { ($arg, $default_case_sens) = ('', 1); }
  if ($arg eq '-cs') { ($arg, $default_case_sens) = ('', 0); }
  if ($arg eq '+plain') { ($arg, $default_plain_text) = ('', 1); }
  if ($arg eq '+preg') { ($arg, $default_plain_text) = ('', 0); }
  if ($arg eq '+lead') { ($arg, $default_leading_only) = ('', 1); }
  if ($arg eq '-lead') { ($arg, $default_leading_only) = ('', 0); }
  if ($arg eq '+trail') { ($arg, $default_trailing_only) = ('', 1); }
  if ($arg eq '-trail') { ($arg, $default_trailing_only) = ('', 0); }

  my $case_sens = $default_case_sens;
  my $plain_text = $default_plain_text;
  my $leading_only = $default_leading_only;
  my $trailing_only = $default_trailing_only;

  unless ($arg eq '')
  {
    my $flags = '';
    unless ($case_sens) { $flags .= 'i'; }

    if ($plain_text) { $arg = quotemeta $arg; }
    if ($leading_only) { $arg = '^' . $arg; }
    if ($trailing_only) { $arg .= '$'; }

    push @regexps, eval "qr/$arg/$flags";
  }
}

while(my $zeile = <STDIN>)
{
  foreach my $regexp (@regexps) { $zeile =~ s/$regexp//ogs; }
  print $zeile;
}
