#!/usr/bin/env perl
use strict;
use warnings;
use SIMS;

SIMS->setup_engine('PSGI');
my $app = sub { SIMS->run(@_) };

