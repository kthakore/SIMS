package SIMS::Controller::Faculty;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Faculty - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/') PathPart('faculty') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();

    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /(g_admin|g_exec|adv_com|fac)/, @roles );

    $c->stash( edit_student_url => $c->uri_for('edit_student') )
      if ( grep ( /(g_admin)/, @roles ) )

}

sub index : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my @found = $c->model('DB::Student')->all();
    $c->stash( search_result => \@found );
}

sub search_student : Chained('base') PathPart('search_student') Args(0) {
    my ( $self, $c ) = @_;

    my $search_text = $c->req->param('search_text');

    my @found;

    if ($search_text) {

        $c->log->debug("**Searching Student on $search_text");
        my $cols_ref = $c->model('DB::Student')->result_source()->_columns();
        my @cols     = keys %$cols_ref;

        my @search_set = ();

        foreach (@cols) {
            unless ( $_ eq 'id' ) {
                push( @search_set,
                    ( $_ => { like => '%' . $search_text . '%' } ) );
            }
        }

        @found = $c->model('DB::Student')->search( \@search_set );

    }
    elsif ( !exists( $c->stash->{search_result} ) ) {
        @found = $c->model('DB::Student')->all();

    }

    if ( $#found > -1 ) {

        $c->flash( search_message => "" );
        $c->stash( search_result => \@found );
    }
    else {
        $c->flash( search_message => "No students found " );
    }
    $c->stash( template => 'faculty/index.tt' );

}

sub view_student : Chained('base') PathPath('view_student') Args(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(
        template => 'student/index.tt',
        student  => $c->model('DB::Student')->find($id)
    );
}

sub edit_student : Chained('base') PathPath('edit_student') Args(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(
        edit_student_url => $c->uri_for('edit_student') . "/$id",
        student          => $c->model('DB::Student')->find($id),
        template         => 'student/edit.tt'
    );
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

sub view_report : Chained('base') PathPart('view_report') Args(0) {
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
