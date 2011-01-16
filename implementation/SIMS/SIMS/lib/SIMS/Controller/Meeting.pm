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

	$c->stash( advisors => \@advisors );
	}

	$c->stash( meeting => $meeting );

	unless( $c->stash->{possible_advisors} )
	{
		my $adv = $c->model('DB::User')->faculty_users();
		$c->stash->{possible_advisors} = $adv;
	}

	$c->stash->{assign_advisor_url} = $c->uri_for('/meeting')."/$m_id/assign_advisor";


}

sub cancel : Chained('base') :PathPart('cancel') :Args(0) {
	my( $self, $c ) = @_;

	$c->stash->{meeting}->delete();	
	$c->response->redirect( '/' );
}

sub assign_advisor : Chained('base') :PartPart('assign_advisor') :Args(1) {
	my( $self, $c, $id ) = @_;

	try 
	{
		my $user_m = $c->model('DB::MeetingAdvisor')->find( $c->stash->{meeting}->id(), $id );
		unless( $user_m )
		{
			my $user = $c->model('DB::User')->find($id);
			$c->stash->{meeting}->create_related( 'meeting_advisors', {advisor_id => $user->id()} );
			$c->stash->{message} = "Added Advisor" ;
		}
		else	
		{
			$c->stash->{message} = "Advisor already added";
		}
		# Make a confirmation and send an email

	}
	catch
	{
		$c->stash->{message} = "Problem: $_" ;
	};

	$c->stash->{template} = 'meeting/index.tt';
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
