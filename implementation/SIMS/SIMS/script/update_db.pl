use strict;
use warnings;
use DBI;

#unlink 'sims.db';

#`sqlite3 sims.db <sims.sql`;

`script/sims_create.pl model DB DBIC::Schema SIMS::Schema create=static overwrite_modifications components=TimeStamp,EncodedColumn 'dbi:Pg:dbname=SIMS;host=127.0.0.1;' 'SIMS' 'SIMS' quote_char='"'`;

`perl script/encode_pass.pl`

