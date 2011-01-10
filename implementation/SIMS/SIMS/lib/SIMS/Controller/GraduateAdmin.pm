package SIMS::Controller::GraduateAdmin;
use Moose;
use Try::Tiny;
use namespace::autoclean;
use DateTime::Format::DateParse;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::GraduateAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/') PathPart('graduateadmin') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();

    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /(g_admin)/, @roles );

    my @events =
      $c->model('DB::Event')
      ->search( {}, { order_by => { -desc => 'timestamp' } } );
    $c->stash( events => \@events );
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

}

sub edit_student : Chained('base') PathPart('edit_student') Args(1) {
    my ( $self, $c, $id ) = @_;
    _handle_edit_stash(@_);
    if ( $c->req->param('submit') ) {
        $c->stash->{student}->update(
            {
                name       => $c->req->param('name'),
                type       => $c->req->param('type'),
                address    => $c->req->param('address'),
                address2   => $c->req->param('address2'),
                city       => $c->req->param('city'),
                province   => $c->req->param('province'),
                postalcode => $c->req->param('postalcode'),
                phone      => $c->req->param('phone'),
                location   => $c->req->param('location'),
            }
        );

        $c->stash( message => "Updated user!" );
    }

}

sub add_plan : Chained('base') PathPart('add_plan') Args(1) {
    my ( $self, $c, $id ) = @_;
    _handle_edit_stash(@_);

    if ( $c->req->param('submit_plan') ) {
        try {
            my $plan =
              $c->model('DB::Plan')
              ->create( { name => $c->req->param('plan_name') } );

            $c->stash->{student}
              ->create_related( 'plan_students', { plan_id => $plan->id } );

            $c->stash( message => "Plan Added!" );
        }
        catch {
            $c->stash( message => "Problem $_" );
        };
    }
}

sub add_term : Chained('base') PathPart('add_term') Args(1) {
    my ( $self, $c, $id ) = @_;
    _handle_edit_stash(@_);

    if ( $c->req->param('submit_term') ) {
        try {
            my $date = DateTime::Format::DateParse->parse_datetime( $c->req->param('termdate') );
            my $term = $c->model('DB::Term')->create(
                {
                    termdate => $date,
                    length   => $c->req->param('termlength')
                }
            );

            $c->stash->{student}
              ->create_related( 'term_students', { term_id => $term->id } );

            $c->stash( message => "Term Added!" );
        }
        catch {
            $c->stash( message => "Problem $_" );
        };
    }
}

sub add_funding : Chained('base') PathPart('add_funding') Args(2) {
	my ( $self, $c, $id, $term_id ) = @_;
	 _handle_edit_stash(@_);

	 if ( $c->req->param('submit_funding') ) {
        try {

	    my $start_date = DateTime::Format::DateParse->parse_datetime( $c->req->param('start') );
    	my $end_date = DateTime::Format::DateParse->parse_datetime( $c->req->param('end') );


           my $term = $c->model('DB::Term')->find($term_id);
			
			my $fund = $c->model('DB::Fund')->create(
				{
					type => $c->req->param('f_type'),
					value =>  $c->req->param('f_value'),
					start => $start_date,
					end => $end_date
				}
			);

            $term->create_related( 'term_fundings', { fund_id => $fund->id } );

            $c->stash( message => "Funding Added!" );
        }
        catch {
            $c->stash( message => "Problem $_" );
        };
    }

}

sub assign_student_terms : Chained('/') : PathPart('assign_student') : Args(0) {

}

sub assign_adv_terms : Chained('/') : PathPart('adv_student') : Args(0) {

}

sub _handle_edit_stash {

    my ( $self, $c, $id ) = @_;

    $c->stash(
        edit_student_url => $c->uri_for('edit_student') . "/$id",
        add_plan_url     => $c->uri_for('add_plan') . "/$id",
		add_funding_url  => $c->uri_for('add_funding')."/$id",
        add_term_url     => $c->uri_for('add_term') . "/$id",
        template         => 'student/edit.tt'
    );

    $c->stash( student => $c->model('DB::Student')->find($id), )
      unless $c->stash->{student} && $c->stash->{student}->id == $id;

}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
