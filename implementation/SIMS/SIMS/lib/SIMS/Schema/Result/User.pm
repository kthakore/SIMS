package SIMS::Schema::Result::User;

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

SIMS::Schema::Result::User

=cut

__PACKAGE__->table("User");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email_address

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email_address",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("email_address_unique", ["email_address"]);
__PACKAGE__->add_unique_constraint("username_unique", ["username"]);

=head1 RELATIONS

=head2 students

Type: has_many

Related object: L<SIMS::Schema::Result::Student>

=cut

__PACKAGE__->has_many(
  "students",
  "SIMS::Schema::Result::Student",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supervisors

Type: has_many

Related object: L<SIMS::Schema::Result::Supervisor>

=cut

__PACKAGE__->has_many(
  "supervisors",
  "SIMS::Schema::Result::Supervisor",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<SIMS::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "SIMS::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-02 21:36:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YDaDcD9UJvQkLW/zvaTw+Q

__PACKAGE__->add_columns(
        '+password' => {
            encode_column       => 1,
            encode_class        => 'Digest',
            encode_args         => {salt_length => 10},
            encode_check_method => 'check_password',
        },
    );


__PACKAGE__->many_to_many(roles => 'user_roles', 'role');


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
