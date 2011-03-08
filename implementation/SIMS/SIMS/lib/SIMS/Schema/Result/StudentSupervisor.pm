package SIMS::Schema::Result::StudentSupervisor;

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

SIMS::Schema::Result::StudentSupervisor

=cut

__PACKAGE__->table("StudentSupervisor");

=head1 ACCESSORS

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 supervisor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "supervisor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("student_id", "supervisor_id");

=head1 RELATIONS

=head2 supervisor

Type: belongs_to

Related object: L<SIMS::Schema::Result::Supervisor>

=cut

__PACKAGE__->belongs_to(
  "supervisor",
  "SIMS::Schema::Result::Supervisor",
  { id => "supervisor_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-07 23:32:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wvQpDVXxmeK1E3I9gSWj2w
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/StudentSupervisor.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::StudentSupervisor;

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

SIMS::Schema::Result::StudentSupervisor

=cut

__PACKAGE__->table("StudentSupervisor");

=head1 ACCESSORS

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 supervisor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "supervisor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("student_id", "supervisor_id");

=head1 RELATIONS

=head2 supervisor

Type: belongs_to

Related object: L<SIMS::Schema::Result::Supervisor>

=cut

__PACKAGE__->belongs_to(
  "supervisor",
  "SIMS::Schema::Result::Supervisor",
  { id => "supervisor_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-10 11:02:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:toCmkJ3qJN4iRegJM41F+g


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/StudentSupervisor.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
