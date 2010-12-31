use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SIMS' }
BEGIN { use_ok 'SIMS::Controller::Faculty' }

ok( request('/faculty')->is_success, 'Request should succeed' );
done_testing();
