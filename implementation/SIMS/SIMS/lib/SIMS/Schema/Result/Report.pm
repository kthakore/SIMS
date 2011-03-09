package SIMS::Schema::Result::Report;

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

SIMS::Schema::Result::Report

=cut

__PACKAGE__->table("Report");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: nextval('"Report_id_seq"'::regclass)
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 query

  data_type: 'text'
  is_nullable: 1

=head2 datum

  data_type: 'text'
  is_nullable: 1

=head2 cols

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type     => "integer",
    default_value => \"nextval('\"Report_id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "name",
  { data_type => "text", is_nullable => 1 },
  "query",
  { data_type => "text", is_nullable => 1 },
  "datum",
  { data_type => "text", is_nullable => 1 },
  "cols",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07009 @ 2011-03-08 01:06:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b7/5iP3ExYMr9U6jP6DAQg
# These lines were loaded from '/usr/local/share/perl/5.10.1/SIMS/Schema/Result/Report.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::Report;

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

SIMS::Schema::Result::Report

=cut

__PACKAGE__->table("Report");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 query

  data_type: 'text'
  is_nullable: 1

=head2 datum

  data_type: 'text'
  is_nullable: 1

=head2 cols

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "query",
  { data_type => "text", is_nullable => 1 },
  "datum",
  { data_type => "text", is_nullable => 1 },
  "cols",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-07 23:32:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L+FZjs8FiLg+brSKzZIBfw
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Report.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::Report;

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

SIMS::Schema::Result::Report

=cut

__PACKAGE__->table("Report");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 query

  data_type: 'text'
  is_nullable: 1

=head2 datum

  data_type: 'text'
  is_nullable: 1

=head2 cols

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "query",
  { data_type => "text", is_nullable => 1 },
  "datum",
  { data_type => "text", is_nullable => 1 },
  "cols",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-31 13:37:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HTX7PLUqJlsL+X33Q/PGQA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Report.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/usr/local/share/perl/5.10.1/SIMS/Schema/Result/Report.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
