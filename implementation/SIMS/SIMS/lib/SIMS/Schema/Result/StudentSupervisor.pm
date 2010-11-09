package SIMS::Schema::Result::StudentSupervisor;

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

SIMS::Schema::Result::StudentSupervisor

=cut

__PACKAGE__->table("StudentSupervisor");

=head1 ACCESSORS

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
  "studentid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
  "supervisorid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-09 08:02:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RUXJ9JFhXWqQaaWnU775cw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
