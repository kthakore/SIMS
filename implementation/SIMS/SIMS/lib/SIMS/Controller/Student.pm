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

sub base : Chained('/') PathPart('student') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();
    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /(student)/, @roles );

    my $id = $c->user->id;
    $c->stash->{student} =
      $c->model('DB::Student')->search( { user_id => $id } )->single();

    $c->log->debug( "Looking at $id found " . $c->stash->{student} );

}

sub index : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
}

sub edit : Chained('base') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( edit_student_url => $c->uri_for('edit') );

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

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
