package SIMS::Schema::ResultSet::User;

use strict;
use warnings;

use Class::Method::Modifiers;
use namespace::autoclean;
use base 'DBIx::Class::ResultSet';

sub faculty_users
{
	my $self = shift;

	my @userroles = $self->result_source->schema()->resultset('UserRole')->search([{role_id => 1 }, {role_id => 2}, {role_id => 5}]);

	my @users;

	push (@users, $_->user) foreach( @userroles );

	return \@users;
}

1;
