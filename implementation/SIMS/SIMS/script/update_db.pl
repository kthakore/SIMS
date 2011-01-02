use strict;
use warnings;
use DBI;

unlink 'sims.db';

`sqlite3 sims.db <sims.sql`;

`script/sims_create.pl model DB DBIC::Schema SIMS::Schema create=static components=TimeStamp,EncodedColumn 'dbi:SQLite:dbname=sims.db' '' ''`;

`perl script/encode_pass.pl`

