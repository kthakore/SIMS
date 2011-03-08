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

=head2 plan_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "plan_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("plan_id", "student_id");

=head1 RELATIONS

=head2 plan

Type: belongs_to

Related object: L<SIMS::Schema::Result::Plan>

=cut

__PACKAGE__->belongs_to(
  "plan",
  "SIMS::Schema::Result::Plan",
  { id => "plan_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 student

Type: belongs_to

Related object: L<SIMS::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "SIMS::Schema::Result::Student",
  { id => "student_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-08 01:01:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MwvX0q+NNnXcQgFaagsOrQ
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/PlanStudent.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

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

=head2 plan_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "plan_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("plan_id", "student_id");

=head1 RELATIONS

=head2 student

Type: belongs_to

Related object: L<SIMS::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "SIMS::Schema::Result::Student",
  { id => "student_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 11:02:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KHv1QFvHNQTXEwpTT+xBnA

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
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/PlanStudent.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
