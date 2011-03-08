use strict;
use warnings;

`sh script/drop_tables.sh`;

`psql -h 127.0.0.1 --password -U SIMS SIMS -f pgsql.sql`;

`rm lib/SIMS/Schema/Result/*.pm lib/SIMS/Schema.pm lib/SIMS/Model/DB.pm`;

`script/sims_create.pl model DB DBIC::Schema SIMS::Schema create=static overwrite_modifications components=TimeStamp,EncodedColumn 'dbi:Pg:dbname=SIMS;host=127.0.0.1;' 'SIMS' 'SIMS' quote_char='"'`;

`perl script/encode_pass.pl`

