package SIMS::Schema::Result::Supervisor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SIMS::Schema::Result::Supervisor

=cut

__PACKAGE__->table("Supervisor");

=head1 ACCESSORS

=head2 id

  data_type: 'int'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 speedcode

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "int", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "speedcode",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 student_supervisors

Type: has_many

Related object: L<SIMS::Schema::Result::StudentSupervisor>

=cut

__PACKAGE__->has_many(
  "student_supervisors",
  "SIMS::Schema::Result::StudentSupervisor",
  { "foreign.supervisorid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-09 08:02:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SVkOLDDPVhKc9KW6sM8ElA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
