package SIMS::Controller::Report;
use Moose;
use namespace::autoclean;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Report - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub base : Chained('/') PathPart('report') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();

    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /(g_admin)/, @roles );
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

}

sub add_query : Chained('base') : PathPart('add_query') : Args(0) {
	my ( $self, $c ) = @_;

	$c->response->body( Dumper $c->request->params() );


}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
