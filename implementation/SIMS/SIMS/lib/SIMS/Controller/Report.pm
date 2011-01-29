package SIMS::Controller::Report;
use Moose;
use namespace::autoclean;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Report - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub base : Chained('/') PathPart('report') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();

    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /(g_admin)/, @roles );
	
	$c->stash->{student_cols}= $self->_prepare_columns($c, 'DB::Student') unless $c->stash->{student_cols};
	$c->stash->{supervisor_cols}= $self->_prepare_columns($c, 'DB::Supervisor') unless $c->stash->{supervisor_cols};
	$c->stash->{advisor_cols}= $self->_prepare_columns($c, 'DB::MeetingAdvisor') unless $c->stash->{advisor_cols};

}


sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

}

sub add_query : Chained('base') : PathPart('add_query') : Args(0) {
	my ( $self, $c ) = @_;

	$c->stash(template => 'report/index.tt' );

}

sub test_query : Chained('base') : PathPart('test_query') : Args(0) {
	my ( $self, $c ) = @_;

		my $query = {};
	foreach(0..($c->req->param('count')-1))
	{
		$query->{$c->req->{parameters}->{"column_$_"}} = 
		{ $c->req->{parameters}->{"condition_$_"} =>  $c->req->{parameters}->{"text_$_"} };
	}

	my @foo =$c->model('DB::Student')->search( $query )->all();

	$c->stash( result_col => $self->_prepare_columns($c, 'DB::Student')); 
	$c->stash( result_record => \@foo );
	$c->stash(template => 'report/index.tt' );

}

sub _prepare_columns
{
	my ($self, $c , $db ) = @_;

	my @stu_cols = $c->model($db)->result_source()->_columns();

	my $student_cols;

	foreach(@stu_cols)
		{
			my @key = keys(%$_);
			foreach( sort(@key ))
			{
				push( @$student_cols, { value => $_, text => $_ } );
			}
		}
	return $student_cols;
}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
