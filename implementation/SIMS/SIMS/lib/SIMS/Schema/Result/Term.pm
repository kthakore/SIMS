package SIMS::Schema::Result::Term;

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

SIMS::Schema::Result::Term

=cut

__PACKAGE__->table("Term");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 termdate

  data_type: 'date'
  is_nullable: 1

=head2 length

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "termdate",
  { data_type => "date", is_nullable => 1 },
  "length",
  { data_type => "float", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 term_fundings

Type: has_many

Related object: L<SIMS::Schema::Result::TermFunding>

=cut

__PACKAGE__->has_many(
  "term_fundings",
  "SIMS::Schema::Result::TermFunding",
  { "foreign.term_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_students

Type: has_many

Related object: L<SIMS::Schema::Result::TermStudent>

=cut

__PACKAGE__->has_many(
  "term_students",
  "SIMS::Schema::Result::TermStudent",
  { "foreign.term_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 17:24:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hhRXYONSY/uO5FwwPZG5Rw

__PACKAGE__->many_to_many( students => 'term_students', 'student');

__PACKAGE__->many_to_many( fundings => 'term_fundings', 'fund');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
