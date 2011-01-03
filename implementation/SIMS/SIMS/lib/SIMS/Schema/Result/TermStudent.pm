package SIMS::Schema::Result::TermStudent;

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

SIMS::Schema::Result::TermStudent

=cut

__PACKAGE__->table("TermStudent");

=head1 ACCESSORS

=head2 id

  data_type: 'int'
  is_nullable: 0

=head2 termid

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=head2 studentid

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "int", is_nullable => 0 },
  "termid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
  "studentid",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

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

=head2 termid

Type: belongs_to

Related object: L<SIMS::Schema::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "termid",
  "SIMS::Schema::Result::Term",
  { id => "termid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-02 21:36:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:whCJG6r3ljkA4t5pgrY+KA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
