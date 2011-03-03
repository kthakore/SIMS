#!/usr/bin/env perl
use strict;
use warnings;

use Plack::Builder;
use SIMS;

SIMS->setup_engine('PSGI');
my $app = sub { SIMS->run(@_) };

builder {
 enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' }
        "Plack::Middleware::ReverseProxy";
 $app;
};

