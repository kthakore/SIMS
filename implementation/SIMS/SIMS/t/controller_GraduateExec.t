use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SIMS' }
BEGIN { use_ok 'SIMS::Controller::GraduateExec' }

ok( request('/graduateexec')->is_success, 'Request should succeed' );
done_testing();
