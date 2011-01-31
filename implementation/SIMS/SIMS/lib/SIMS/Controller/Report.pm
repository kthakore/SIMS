package SIMS::Controller::Report;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Try::Tiny;
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

	$c->stash->{datums} = _get_datums($c) unless $c->stash->{datums};
}


sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

}

sub add_query : Chained('base') : PathPart('add_query') : Args(0) {
	my ( $self, $c ) = @_;

	if( $c->req->param('datum') )
	{
		try{

			my $query = _generate_query($c);
			my $report = $c->model('DB::Report')->create(
			{
				name => $c->req->param('query_name'),
				query => Dumper ($query)
			}
			);
			$c->stash(message => "Created ".$report->id() );	
		}
		catch
		{
		$c->stash( message => "Problem $_");

		};

	}

	$c->stash(template => 'report/index.tt' );

}

sub test_query : Chained('base') : PathPart('test_query') : Args(0) {
	my ( $self, $c ) = @_;

	

	if( $c->req->param('datum') )
	{
		try{

			my $query = _generate_query($c);
			my @cols = $c->req->param('columns'); 
			$c->log->debug( $c->req->param('datum'). " and ". Dumper ($query )) ;
			my @foo = $c->model($c->req->param('datum'))->search( $query );

			my @records; 
			foreach(@foo )
			{
				my $res = $_;
				my @record; 

				$res->id();
			
				
				foreach( @cols)
				{
					push @record, ( $res->{_column_data}->{$_});
				}

					push @records, \@record; 

			}

			$c->stash( result_col => \@cols); 
			$c->stash( result_record => \@records );
		}
		catch
		{
			$c->stash( message => "Problem $_");

		};
	}
	$c->stash(template => 'report/index.tt' );

}

sub _prepare_columns
{
	my ($c , $db ) = @_;

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

sub _generate_query
{
	my $c = shift; 
			my $query = {};


			foreach(0..($c->req->param('count')-1))
			{
				my $prev_query = $query;
				my $cur_col = $c->req->{parameters}->{"column_$_"};
				my $cur_query = { $c->req->{parameters}->{"condition_$_"} =>  $c->req->{parameters}->{"text_$_"} };
				my $cur_op = $c->req->{parameters}->{"op_$_"};
				if( $cur_op =~ /and|or/ )
				{
					$query = {"-$cur_op" =>  [$prev_query , {$cur_col  => $cur_query}] }

				}
				else
				{
					$query->{$cur_col} = $cur_query;
				}
				
			}

	return $query;
}

sub _get_datums
{
	my ($c) = shift;

	my $class_mappings = $c->user->result_source->{schema}->{class_mappings};

	my @db = keys %{$class_mappings};

	my @datums;
	foreach( @db )
	{
		next if $_ =~ /SIMS::Schema/;
		my $cm = $_;
		$_ =~ s/SIMS::Model:://g;
		push (@datums, { value => $_, text => $class_mappings->{$cm}, cols => _prepare_columns($c, $_) });
	}

	return \@datums;
}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
