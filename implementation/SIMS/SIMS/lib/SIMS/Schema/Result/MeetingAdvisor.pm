package SIMS::Schema::Result::MeetingAdvisor;

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

SIMS::Schema::Result::MeetingAdvisor

=cut

__PACKAGE__->table("MeetingAdvisor");

=head1 ACCESSORS

=head2 meeting_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 advisor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 confirmation

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "meeting_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "advisor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "confirmation",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("meeting_id", "advisor_id");

=head1 RELATIONS

=head2 confirmation

Type: belongs_to

Related object: L<SIMS::Schema::Result::MeetingConfirmation>

=cut

__PACKAGE__->belongs_to(
  "confirmation",
  "SIMS::Schema::Result::MeetingConfirmation",
  { id => "confirmation" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 advisor

Type: belongs_to

Related object: L<SIMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "advisor",
  "SIMS::Schema::Result::User",
  { id => "advisor_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 meeting

Type: belongs_to

Related object: L<SIMS::Schema::Result::Meeting>

=cut

__PACKAGE__->belongs_to(
  "meeting",
  "SIMS::Schema::Result::Meeting",
  { id => "meeting_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-16 13:11:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ewPfmwtchNKA6H5eDPbi6Q


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
