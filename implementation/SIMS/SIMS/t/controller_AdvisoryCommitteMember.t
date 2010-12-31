use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SIMS' }
BEGIN { use_ok 'SIMS::Controller::AdvisoryCommitteMember' }

ok( request('/advisorycommittemember')->is_success, 'Request should succeed' );
done_testing();
