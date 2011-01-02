package SIMS::Controller::Student;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Student - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') PathPart('student') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();
	$c->response->redirect($c->uri_for('/unauthorized')) unless( grep /(student)/, @roles );


	 my $id = $c->user->id; 
	 $c->stash->{student}   = $c->model('DB::Student')->search({ user_id => $id })->single();

	
	$c->log->debug("Looking at $id found ".$c->stash->{student} );

}
sub object : Chained('base') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
   
}

sub view : Chained('object') Args(0) {

}

sub report : Chained('object') Args(0) {

}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
