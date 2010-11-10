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

=head2 Collection

Show all students in the current DB

=cut

sub collection : Chained('/base') PathPart('student') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{collection} = $c->model('DB::Student');
}

sub view_collection : Chained('collection') Args(0) PathPart('') {
}

=head2 Object 

Operations on a single student by id 

=cut 

sub object : Chained('collection') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash->{student} = $c->model('DB::Student')->find($id);

}

sub view : Chained('object') Args(0) {
}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
