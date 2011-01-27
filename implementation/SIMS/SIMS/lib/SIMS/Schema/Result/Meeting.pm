package SIMS::Schema::Result::Meeting;

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

SIMS::Schema::Result::Meeting

=cut

__PACKAGE__->table("Meeting");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 datetime

  data_type: 'datetime'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=head2 progress

  data_type: 'text'
  is_nullable: 1

=head2 agreement

  data_type: 'text'
  is_nullable: 1

=head2 student_sign

  data_type: 'text'
  is_nullable: 1

=head2 locked

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "datetime",
  { data_type => "datetime", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "progress",
  { data_type => "text", is_nullable => 1 },
  "agreement",
  { data_type => "text", is_nullable => 1 },
  "student_sign",
  { data_type => "text", is_nullable => 1 },
  "locked",
  { data_type => "integer", is_nullable => 1 },
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

=head2 meeting_advisors

Type: has_many

Related object: L<SIMS::Schema::Result::MeetingAdvisor>

=cut

__PACKAGE__->has_many(
  "meeting_advisors",
  "SIMS::Schema::Result::MeetingAdvisor",
  { "foreign.meeting_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 meeting_comments

Type: has_many

Related object: L<SIMS::Schema::Result::MeetingComment>

=cut

__PACKAGE__->has_many(
  "meeting_comments",
  "SIMS::Schema::Result::MeetingComment",
  { "foreign.meeting_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-25 22:37:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N8/1nzM9uyCi4vEvnHpiWg

__PACKAGE__->many_to_many( advisors => 'meeting_advisors', 'advisor' );

__PACKAGE__->has_many(
  "comments",
  "SIMS::Schema::Result::MeetingComment",
  { "foreign.meeting_id" => "self.id", "foreign.type" => "'comment'" },
  { cascade_copy => 0, cascade_delete => 0 },
);
# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
