package SIMS::Controller::Faculty;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Faculty - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') PathPart('faculty') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();

	$c->response->redirect($c->uri_for('/unauthorized')) unless( grep /(g_admin|g_exec|adv_com|fac)/, @roles );
}

sub index :Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;

}



sub search_student :Chained('base') PathPart('search_student') Args(0) {
    my ( $self, $c ) = @_;

	my $search_text = $c->req->param('search_text');

	$c->log->debug("**Searching Student on $search_text");
	my @found = $c->model('DB::Student')->search({ name => { like => '%' . $search_text . '%' }});

	if($#found > -1)
	{
	$c->stash( search_result => \@found );
	}
	else
	{
	$c->flash( search_message => "No students found ");
	} 
	$c->stash( template => 'faculty/index.tt' );


}


sub view_report :Chained('base') PathPart('view_report') Args(0) {
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
