package SIMS::Schema::Result::MeetingComment;

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

SIMS::Schema::Result::MeetingComment

=cut

__PACKAGE__->table("MeetingComments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 meeting_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 advisor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 advisor_sign

  data_type: 'text'
  is_nullable: 1

=head2 comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "meeting_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "advisor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "advisor_sign",
  { data_type => "text", is_nullable => 1 },
  "comment",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 advisor

Type: belongs_to

Related object: L<SIMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "advisor",
  "SIMS::Schema::Result::User",
  { id => "advisor_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 meeting

Type: belongs_to

Related object: L<SIMS::Schema::Result::Meeting>

=cut

__PACKAGE__->belongs_to(
  "meeting",
  "SIMS::Schema::Result::Meeting",
  { id => "meeting_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-11 00:04:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3GC/b+btgw/zKdDW86GliQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
