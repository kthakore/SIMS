package SIMS::Controller::Meeting;
use Moose;
use Try::Tiny;
use SIMS::Controller::Helper;
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
	my @advisors = $meeting->meeting_advisors();
	my @advisors_id;
	push( @advisors_id, $_->advisor_id())  foreach( @advisors );

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

	my $new_meeting_adv;
	my $new_meeting_confirm;
	try 
	{
		my $user_m = $c->model('DB::MeetingAdvisor')->find( $c->stash->{meeting}->id(), $id );
		unless( $user_m )
		{
			my $user = $c->model('DB::User')->find($id);
			my $new_meeting_adv = $c->stash->{meeting}->create_related( 'meeting_advisors', {advisor_id => $user->id()} );
			$c->stash->{message} = "Added Advisor" ;

			#making a confirmation record
			$new_meeting_confirm = $c->model('DB::MeetingConfirmation')->create( { key => SIMS::Controller::Helper::random_confirm_key(32), status => 'Just added', details => '' } ); 
			$new_meeting_adv->update( { confirmation => $new_meeting_confirm->id() } );

			SIMS::Controller::Helper::send_email( $user->email_address(), "Confirmation required for meeting ", 
					"Log in and Confirm your attendence at ".$c->uri_for('/').'meeting/'.$c->stash->{meeting}->id().'/confirm/'.$new_meeting_confirm->key());
					

		}
		else	
		{
			$c->stash->{message} = "Advisor already added";
		}
		# Make a confirmation and send an email

	}
	catch
	{
		if( $new_meeting_adv )
		{
			$new_meeting_adv->delete();
		}
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

sub confirm : Chained('base') :PathPart('confirm') :Args(1) {
	my ( $self, $c, $id) = @_;

	my $con = $c->model('DB::MeetingConfirmation')->search( {key=> $id} )->single(); 

	my $advisor = $con->meeting_advisors()->single();

	 $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( $c->user->id ==  $advisor->advisor_id() );


	$c->response->body( "Got confirmation correctly at ".$con->id().".</ br> and user is". $c->user->id().". And ".	$advisor->advisor_id() );
	
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
