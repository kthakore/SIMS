package SIMS::Schema::ResultSet::Student;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::ResultSet';

use DateTime;
use Data::Dumper;
use SIMS::Schema;

after 'create' => sub
{
	my $self = shift;

	my $h = shift;
	$self->result_source->schema()->resultset('Event')->create(
	{
		id => 23,
		ref_id => $h->{user_id},
		refers_to => 'STUDENT',
		type => 'DB',
		timestamp => DateTime->now(), 
		description => "Added new student"
	
	}
	);
};

__PACKAGE__->meta->make_immutable; 
1;
