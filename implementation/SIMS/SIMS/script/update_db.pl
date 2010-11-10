use strict;
use warnings;
use DBI;

unlink 'sims.db';

`sqlite3 sims.db < ../sims.sql`;

`script/sims_create.pl model DB DBIC::Schema SIMS::Schema create=static 'dbi:SQLite:dbname=sims.db' '' ''`;

my $dbh = DBI->connect( "dbi:SQLite:dbname=sims.db", "", "" );
$dbh->do( '
			 	INSERT INTO "Student" VALUES ("1","Kartik Thakore","New Student","123 Numbers blvd","--","London","ON","L2T2W1","123456789","123@email.com","MSC");
			'
);

