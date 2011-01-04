package SIMS::Controller::GraduateAdmin;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::GraduateAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub base :Chained('/') PathPart('graduateadmin') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();

	$c->response->redirect($c->uri_for('/unauthorized')) unless( grep /(g_admin)/, @roles );
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;

}


=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
