use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SIMS' }
BEGIN { use_ok 'SIMS::Controller::AdvCommMember' }

ok( request('/advcommmember')->is_success, 'Request should succeed' );
done_testing();
