package SIMS::Schema::Result::TermFunding;

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

SIMS::Schema::Result::TermFunding

=cut

__PACKAGE__->table("TermFunding");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 fund_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fund_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_id", "fund_id");

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<SIMS::Schema::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "SIMS::Schema::Result::Term",
  { id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 fund

Type: belongs_to

Related object: L<SIMS::Schema::Result::Fund>

=cut

__PACKAGE__->belongs_to(
  "fund",
  "SIMS::Schema::Result::Fund",
  { id => "fund_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07009 @ 2011-03-08 01:06:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:emKn9xBWf0we3iVLp5pXiw
# These lines were loaded from '/usr/local/share/perl/5.10.1/SIMS/Schema/Result/TermFunding.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::TermFunding;

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

SIMS::Schema::Result::TermFunding

=cut

__PACKAGE__->table("TermFunding");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 fund_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fund_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_id", "fund_id");

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<SIMS::Schema::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "SIMS::Schema::Result::Term",
  { id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 fund

Type: belongs_to

Related object: L<SIMS::Schema::Result::Fund>

=cut

__PACKAGE__->belongs_to(
  "fund",
  "SIMS::Schema::Result::Fund",
  { id => "fund_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-07 23:32:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UhOyJHo8xxmYn8OgPj0QqA
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/TermFunding.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::TermFunding;

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

SIMS::Schema::Result::TermFunding

=cut

__PACKAGE__->table("TermFunding");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 fund_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fund_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_id", "fund_id");

=head1 RELATIONS

=head2 fund

Type: belongs_to

Related object: L<SIMS::Schema::Result::Fund>

=cut

__PACKAGE__->belongs_to(
  "fund",
  "SIMS::Schema::Result::Fund",
  { id => "fund_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 term

Type: belongs_to

Related object: L<SIMS::Schema::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "SIMS::Schema::Result::Term",
  { id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 17:24:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mMnGw8FvnQC8S1Tyx6Tn0Q


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/TermFunding.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/usr/local/share/perl/5.10.1/SIMS/Schema/Result/TermFunding.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
