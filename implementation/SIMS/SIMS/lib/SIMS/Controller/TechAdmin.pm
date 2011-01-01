package SIMS::Controller::TechAdmin;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::TechAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.



=head1 METHODS

=cut
=head2 base 
Check if the user is a tech admin

=cut

sub base :Chained('/') PathPart('techadmin') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();
	$c->response->redirect($c->uri_for('/unauthorized')) unless( @roles ~~ 'techadmin' );
}

=head2 index

=cut

sub index :Chained('base') PathPart('') Args(0) {
	my ( $self, $c ) = @_;

	foreach my $role (  $c->user->roles() )
	{
		$c->log->debug('***Root::auto User is '.$role);
	}
	$c->response->body('Matched SIMS::Controller::TechAdmin in TechAdmin.');
}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

	   This library is free software. You can redistribute it and/or modify
	   it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
