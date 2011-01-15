package SIMS::Controller::Meeting;
use Moose;
use Try::Tiny;
use namespace::autoclean;
use DateTime::Format::DateParse;

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

sub assign_advisor : Chained('base') :PartPart('assign_advisor') :Args(1) {
	my( $self, $c, $id ) = 0;

	try 
	{
		my $user = $c->model('DB::User')->find($id);
		$c->stash->{meeting}->create_related( 'meeting_advisor', {advisors_id => $user->id()} );
		$c->stash->{message} = "Added Advisor" ;

		# Make a confirmation and send an email

	}
	catch
	{
		$c->stash->{message} = "Problem: $_" ;
	};
}

sub update : Chained('base') :PathPart('update') :Args(0) {

my( $self, $c ) = @_;

	if( $c->req->param('meeting_up_submit') )
	{

		my $date = DateTime::Format::DateParse->parse_datetime( $c->req->param('meeting_date') );

		$c->stash->{meeting}->update(
		{
		datetime => $date,
		description => $c->req->param('meeting_desc'),
		}
		);
	}
	$c->stash( template => 'meeting/index.tt' );
}

sub confim : Chained('base') :PathPart('') :Args(1) {
	my ( $self, $c, $id) = @_;
	
	
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
