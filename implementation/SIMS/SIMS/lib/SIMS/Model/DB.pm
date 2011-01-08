package SIMS::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'SIMS::Schema',

    connect_info => {
        dsn      => 'dbi:SQLite:dbname=sims.db',
        user     => '',
        password => '',
    }
);

=head1 NAME

SIMS::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<SIMS>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<SIMS::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.43

=head1 AUTHOR

Kartik Thakore

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
