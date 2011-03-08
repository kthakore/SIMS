package SIMS::Schema::Result::Event;

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

SIMS::Schema::Result::Event

=cut

__PACKAGE__->table("Event");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: nextval('"Event_id_seq"'::regclass)
  is_nullable: 0

=head2 ref_id

  data_type: 'integer'
  is_nullable: 0

=head2 refers_to

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 timestamp

  data_type: 'timestamp'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type     => "integer",
    default_value => \"nextval('\"Event_id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "ref_id",
  { data_type => "integer", is_nullable => 0 },
  "refers_to",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "timestamp",
  { data_type => "timestamp", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-08 01:01:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YyxTzkZhoQE0Y5fCLW65CQ
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Event.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::Event;

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

SIMS::Schema::Result::Event

=cut

__PACKAGE__->table("Event");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 ref_id

  data_type: 'int'
  is_nullable: 1

=head2 refers_to

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 timestamp

  data_type: 'datetime'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ref_id",
  { data_type => "int", is_nullable => 1 },
  "refers_to",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "timestamp",
  { data_type => "datetime", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("ref_id_unique", ["ref_id"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-07 20:05:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xdt97YXPARJkTwL+AzANuQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Event.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
