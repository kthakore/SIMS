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
is_nullable: 1

=head2 password

data_type: 'text'
is_nullable: 1

=head2 email_address

data_type: 'text'
is_nullable: 1

=head2 first_name

data_type: 'text'
is_nullable: 1

=head2 last_name

data_type: 'text'
is_nullable: 1

=head2 active

data_type: 'integer'
is_nullable: 1

=cut

__PACKAGE__->add_columns(
		"id",
		{ data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
		"username",
		{ data_type => "text", is_nullable => 1 },
		"password",
		{              encode_column       => 1,
            encode_class        => 'Digest',
            encode_args         => {salt_length => 10},
            encode_check_method => 'check_password',
},
		"email_address",
		{ data_type => "text", is_nullable => 1 },
		"first_name",
		{ data_type => "text", is_nullable => 1 },
		"last_name",
		{ data_type => "text", is_nullable => 1 },
		"active",
		{ data_type => "integer", is_nullable => 1 },
		);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-29 17:04:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uU6otrATSErqzadwp5YDOw

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(roles => 'UserRoles', 'Role');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
