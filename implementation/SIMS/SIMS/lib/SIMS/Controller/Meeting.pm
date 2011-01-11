package SIMS::Controller::Meeting;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Meeting - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub base : Chained('/') PathPart('meeting') CaptureArgs(1) {
    my ( $self, $c, $m_id ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my $id = $c->user->id;

	$c->log->debug("Searching for $m_id");
	my $meeting = $c->model('DB::Meeting')->find($m_id);

	unless( defined $meeting )
	{
   		 $c->response->redirect( $c->uri_for('/default') )
   	}
	else
	{
	my @advisors = $meeting->advisors();
	my @advisors_id;
	push( @advisors_id, $_->id)  foreach( @advisors );

	$c->log->debug("Student id is ".$meeting->student_id(). "and user id". $id);
    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( $meeting->student() && $meeting->student()->user_id() == $id || grep /$id/, @advisors_id  );
	}

	$c->stash( meeting => $meeting );

}

sub cancel : Chained('base') :PathPart('cancel') :Args(0) {
	my( $self, $c ) = @_;

	$c->stash->{meeting}->delete();	
	$c->response->redirect( '/' );
}

sub index : Chained('base') :PathPart('') :Args(0) {
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
