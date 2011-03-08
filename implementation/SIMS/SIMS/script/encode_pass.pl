    #!/usr/bin/perl

    use strict;
    use warnings;
    use lib 'lib';

    use SIMS::Schema;

    my $schema = SIMS::Schema->connect('dbi:Pg:dbname=SIMS;host=127.0.0.1;port=5432"', 'SIMS', 'SIMS');
		$schema->storage->sql_maker->quote_char('"');
    my @users = $schema->resultset('User')->all;

    foreach my $user (@users) {
        warn "Doing " . $user->id;
        $user->password('mypass');
        $user->update;
    }
