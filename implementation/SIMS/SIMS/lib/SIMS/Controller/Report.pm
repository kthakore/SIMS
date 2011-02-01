package SIMS::Controller::Report;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;
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

	my @reports =  $c->model('DB::Report')->all();

	$c->stash->{reports} = \@reports;

	$c->stash->{datums} = _get_datums($c) unless $c->stash->{datums};
	$c->stash->{eval_arr} = sub { my $foo = decode_json( $_ ); return join( ',', @$foo) };
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
			my $e_query = encode_json $query;
			my @cols = $c->req->param('columns');
			my $e_cols = encode_json \@cols;
			my $report = $c->model('DB::Report')->create(
			{
				name => $c->req->param('query_name'),
				query => $e_query,
				datum => $c->req->param('datum'),
				cols => $e_cols
			}
			);
			$c->response->redirect( $c->uri_for('/report') );
		}
		catch
		{
		$c->stash( message => "Problem $_");

		};

	}

	$c->stash(template => 'report/index.tt' );

}

sub show_query : Chained('base') : PathPart('show_query') : Args(1) {
	my ( $self, $c, $id ) = @_;

	try{
		 	my $report = $c->model('DB::Report')->find( $id );
			my $datum = $report->datum();
			my $cols = decode_json $report->cols();
			my $query = decode_json $report->query();	

			my @results = $c->model( $datum )->search($query);
		
			_show_records( $c, \@results, $cols);
	}
	catch	
	{
			$c->stash( message => "Problem $_");
	};

	$c->stash(template => 'report/index.tt' );
}

sub test_query : Chained('base') : PathPart('test_query') : Args(0) {
	my ( $self, $c ) = @_;

	

	if( $c->req->param('datum') )
	{
		try{

			my $query = _generate_query($c);
			my @columns = $c->req->param('columns'); 
			$c->log->debug( $c->req->param('datum'). " and ". Dumper ($query )) ;
			my @results = $c->model($c->req->param('datum'))->search( $query );
			my $cols = \@columns;
			my $datum_search = \@results;
			_show_records( $c, $datum_search, $cols );
		}
		catch
		{
			$c->stash( message => "Problem $_");

		};
	}
	$c->stash(template => 'report/index.tt' );

}

sub _show_records
{
	my ($c, $datum_search, $cols) = @_;

			my @records; 
			foreach( @$datum_search )
			{
				my $res = $_;
				my @record; 

				$res->id();
			
				
				foreach( @$cols)
				{
					push @record, ( $res->{_column_data}->{$_});
				}

					push @records, \@record; 

			}

			$c->stash( result_col => $cols); 
			$c->stash( result_record => \@records );
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
				if( $cur_op && $cur_op =~ /and|or/ )
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
