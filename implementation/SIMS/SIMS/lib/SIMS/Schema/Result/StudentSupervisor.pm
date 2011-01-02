package SIMS::Schema::Result::StudentSupervisor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 NAME

SIMS::Schema::Result::StudentSupervisor

=cut

__PACKAGE__->table("StudentSupervisor");

=head1 ACCESSORS

=head2 id

  data_type: 'int'
  is_nullable: 0

=head2 studentid

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=head2 supervisorid

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "int", is_nullable => 0 },
  "studentid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
  "supervisorid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 supervisorid

Type: belongs_to

Related object: L<SIMS::Schema::Result::Supervisor>

=cut

__PACKAGE__->belongs_to(
  "supervisorid",
  "SIMS::Schema::Result::Supervisor",
  { id => "supervisorid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 studentid

Type: belongs_to

Related object: L<SIMS::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "studentid",
  "SIMS::Schema::Result::Student",
  { id => "studentid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-01 20:47:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QL6ZWIJhyA9VJFdscARpwQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
