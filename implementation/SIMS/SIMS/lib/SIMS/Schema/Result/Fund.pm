package SIMS::Schema::Result::Fund;

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

SIMS::Schema::Result::Fund

=cut

__PACKAGE__->table("Fund");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'numeric'
  is_nullable: 1

=head2 start

  data_type: 'date'
  is_nullable: 1

=head2 end

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "value",
  { data_type => "numeric", is_nullable => 1 },
  "start",
  { data_type => "date", is_nullable => 1 },
  "end",
  { data_type => "date", is_nullable => 1 },
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
  { "foreign.fund_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-07 23:32:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SbvbA1+ntLUK8e1HNwpK7A
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Fund.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::Fund;

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

SIMS::Schema::Result::Fund

=cut

__PACKAGE__->table("Fund");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'float'
  is_nullable: 1

=head2 start

  data_type: 'date'
  is_nullable: 1

=head2 end

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "value",
  { data_type => "float", is_nullable => 1 },
  "start",
  { data_type => "date", is_nullable => 1 },
  "end",
  { data_type => "date", is_nullable => 1 },
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
  { "foreign.fund_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 17:24:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qv0IvNfqzH15zg+JA6Q9JQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Fund.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
