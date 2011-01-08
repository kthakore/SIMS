use HTML::Clean::Human;

my $c = HTML::Clean::Human->new( $ARGV[0] );

print $c->clean;
