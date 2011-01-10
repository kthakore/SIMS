package SIMS::Schema::Result::PlanStudent;

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

SIMS::Schema::Result::PlanStudent

=cut

__PACKAGE__->table("PlanStudent");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 plan_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "plan_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 student

Type: belongs_to

Related object: L<SIMS::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "SIMS::Schema::Result::Student",
  { id => "student_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 10:32:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UWQUSNxmWxgKv3a/7MoOSg

__PACKAGE__->belongs_to(
  "plan",
  "SIMS::Schema::Result::Plan",
  { id => "plan_id" },
  {
    is_deferrable => 1,
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
