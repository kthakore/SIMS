use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use HTTP::Request::Common;

BEGIN { use_ok 'SIMS' }

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'SIMS');

$mech->host('localhost:3000');
$mech->get('/login');
$mech->submit_form
(
form_number => '0',
fields =>
{
 username => 'advcomm', password => 'mypass'
}
);

ok($mech->get('/advcommmember')->is_success(), "Successfully logged in");

done_testing();
