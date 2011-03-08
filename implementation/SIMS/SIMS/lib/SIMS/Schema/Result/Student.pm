package SIMS::Schema::Result::Student;

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

SIMS::Schema::Result::Student

=cut

__PACKAGE__->table("Student");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 address2

  data_type: 'text'
  is_nullable: 1

=head2 city

  data_type: 'text'
  is_nullable: 1

=head2 province

  data_type: 'text'
  is_nullable: 1

=head2 postalcode

  data_type: 'text'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "address2",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "text", is_nullable => 1 },
  "province",
  { data_type => "text", is_nullable => 1 },
  "postalcode",
  { data_type => "text", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 meetings

Type: has_many

Related object: L<SIMS::Schema::Result::Meeting>

=cut

__PACKAGE__->has_many(
  "meetings",
  "SIMS::Schema::Result::Meeting",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 plan_students

Type: has_many

Related object: L<SIMS::Schema::Result::PlanStudent>

=cut

__PACKAGE__->has_many(
  "plan_students",
  "SIMS::Schema::Result::PlanStudent",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<SIMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "SIMS::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 student_supervisors

Type: has_many

Related object: L<SIMS::Schema::Result::StudentSupervisor>

=cut

__PACKAGE__->has_many(
  "student_supervisors",
  "SIMS::Schema::Result::StudentSupervisor",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_students

Type: has_many

Related object: L<SIMS::Schema::Result::TermStudent>

=cut

__PACKAGE__->has_many(
  "term_students",
  "SIMS::Schema::Result::TermStudent",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-03-07 23:32:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ois5ScGESQ2G4hhZKwvYxQ
# These lines were loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Student.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

package SIMS::Schema::Result::Student;

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

SIMS::Schema::Result::Student

=cut

__PACKAGE__->table("Student");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 address2

  data_type: 'text'
  is_nullable: 1

=head2 city

  data_type: 'text'
  is_nullable: 1

=head2 province

  data_type: 'text'
  is_nullable: 1

=head2 postalcode

  data_type: 'text'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "address2",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "text", is_nullable => 1 },
  "province",
  { data_type => "text", is_nullable => 1 },
  "postalcode",
  { data_type => "text", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<SIMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "SIMS::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 term_students

Type: has_many

Related object: L<SIMS::Schema::Result::TermStudent>

=cut

__PACKAGE__->has_many(
  "term_students",
  "SIMS::Schema::Result::TermStudent",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 plan_students

Type: has_many

Related object: L<SIMS::Schema::Result::PlanStudent>

=cut

__PACKAGE__->has_many(
  "plan_students",
  "SIMS::Schema::Result::PlanStudent",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 student_supervisors

Type: has_many

Related object: L<SIMS::Schema::Result::StudentSupervisor>

=cut

__PACKAGE__->has_many(
  "student_supervisors",
  "SIMS::Schema::Result::StudentSupervisor",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 meetings

Type: has_many

Related object: L<SIMS::Schema::Result::Meeting>

=cut

__PACKAGE__->has_many(
  "meetings",
  "SIMS::Schema::Result::Meeting",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-14 22:37:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F+lvIquYeCAXME4GrRsDqw



__PACKAGE__->many_to_many( supervisors => 'student_supervisors', 'supervisor');
__PACKAGE__->many_to_many( plans => 'plan_students', 'plan');
__PACKAGE__->many_to_many( terms => 'term_students', 'term');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/home/kthakore/.perl5/perls/perl-5.12.2/lib/site_perl/5.12.2/SIMS/Schema/Result/Student.pm' 


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
