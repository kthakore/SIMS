    #!/usr/bin/perl

    use strict;
    use warnings;
	use lib 'lib';

    use SIMS::Schema;

    my $schema = SIMS::Schema->connect('dbi:SQLite:sims.db');

    my @users = $schema->resultset('User')->all;

    foreach my $user (@users) {
		warn "Doing ".$user->id;
        $user->password('mypass');
        $user->update;
    }
