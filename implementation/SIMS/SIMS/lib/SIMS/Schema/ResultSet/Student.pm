package SIMS::Schema::ResultSet::Student;

use strict;
use warnings;

use Class::Method::Modifiers;
use namespace::autoclean;
use base 'DBIx::Class::ResultSet';

use DateTime;
use SIMS::Schema;

after 'create' => sub {
    my $self = shift;

    my $h = shift;
    $self->result_source->schema()->resultset('Event')->create(
        {
            ref_id      => $h->{user_id},
            refers_to   => 'STUDENT',
            type        => 'DB',
            timestamp   => DateTime->now(),
            description => "Added new student"

        }
    );
};

1;
