package SIMS::Controller::Faculty;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Faculty - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') PathPart('faculty') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();

	$c->response->redirect($c->uri_for('/unauthorized')) unless( grep /(g_admin|g_exec|adv_com|fac)/, @roles );
}


sub search_student :Chained('base') PathPart('search_student') Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Search for student .');
}


sub view_report :Chained('base') PathPart('view_report') Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('View Reports');
}


=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
