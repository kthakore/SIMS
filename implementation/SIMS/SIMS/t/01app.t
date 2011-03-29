#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use HTTP::Request::Common;

BEGIN { use_ok 'Catalyst::Test', 'SIMS' }

ok( request('/login')->is_success, 'Request should succeed' );
my $response = request POST '/login', [ username => 'student', password => 'mypass' ];

ok( $response->is_success, 'Logged in' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'SIMS');

$mech->submit_form
(
form_number => '0',
fields =>
{
 username => 'student', password => 'mypass'
}
);

done_testing();
