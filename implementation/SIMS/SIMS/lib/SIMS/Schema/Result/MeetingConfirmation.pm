package SIMS::Schema::Result::MeetingConfirmation;

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

SIMS::Schema::Result::MeetingConfirmation

=cut

__PACKAGE__->table("MeetingConfirmation");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: nextval('"MeetingConfirmation_id_seq"'::regclass)
  is_nullable: 0

=head2 key

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=head2 details

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type     => "integer",
    default_value => \"nextval('\"MeetingConfirmation_id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "key",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "details",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 meeting_advisors

Type: has_many

Related object: L<SIMS::Schema::Result::MeetingAdvisor>

=cut

__PACKAGE__->has_many(
  "meeting_advisors",
  "SIMS::Schema::Result::MeetingAdvisor",
  { "foreign.confirmation" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-08 01:01:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0TSqlnSnKeUm3rhZyOjfkQ
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/MeetingConfirmation.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::MeetingConfirmation;

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

SIMS::Schema::Result::MeetingConfirmation

=cut

__PACKAGE__->table("MeetingConfirmation");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 key

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=head2 details

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "key",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "details",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 meeting_advisors

Type: has_many

Related object: L<SIMS::Schema::Result::MeetingAdvisor>

=cut

__PACKAGE__->has_many(
  "meeting_advisors",
  "SIMS::Schema::Result::MeetingAdvisor",
  { "foreign.confirmation" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-26 18:14:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VoXNgw4U9h4wuxQwt7U3cA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/MeetingConfirmation.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
