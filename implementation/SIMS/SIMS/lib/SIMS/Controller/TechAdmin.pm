package SIMS::Controller::TechAdmin;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::TechAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.



=head1 METHODS

=cut
=head2 base 
Check if the user is a tech admin

=cut

sub base :Chained('/') PathPart('techadmin') CaptureArgs(0) {
	my( $self, $c ) = @_;

	$c->session->{original_URI} = $c->request->uri;
	my @roles = $c->user->roles();
	$c->response->redirect($c->uri_for('/unauthorized')) unless( grep /^t_admin$/, @roles );
}

=head2 index

=cut

sub index :Chained('base') PathPart('') Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{roles} = $c->model('DB::Role');
	$c->stash->{users} = $c->model('DB::User');

#	$c->response->body('Matched SIMS::Controller::TechAdmin in TechAdmin.');
}

sub create :Chained('base') PathPart('create') Args(0) {
	my ( $self, $c ) = @_;

	#Validation of the email? 

                                                                                                                                                              
    my $user = $c->model('DB::User')->create({                                                                                                                
        username => $c->req->param('username'),
        password => $c->req->param('password'),
        email_address => $c->req->param('email_address'),
        last_name     => $c->req->param('last_name'),
		first_name    =>  $c->req->param('first_name'),
		active	=> 1
		
    });

#	$user->add_to_user_roles( role_id => $c->req->param('role_id') );
    $user->create_related( 'user_roles', { role_id => $c->req->param('role_id') }); 
    $c->flash( message => 'User created successfully!' );
    $c->res->redirect( $c->uri_for( $self->action_for('index') ) );

}

sub update_pass :Chained('base') PathPart('update_pass') Args(0) {
my ( $self, $c ) = @_;

	my $user_id = $c->req->param('id');

	my @password_set = ( ( "a"..."z" ), ( "A"..."Z" ), (0 ... 9) );
	#Generate a random password
	my $password = '';
	   $password .=  $password_set[rand()*$#password_set] foreach( 0...8); 

	#Update the field on the user's account
	my $user = $c->model('DB::User')->find( $user_id );

	$c->log->debug("***User setting pasword $password ");
	$user->update( {password => $password } );

	#Email it to the user's email

	 $c->flash( message => "User $user_id password  updated successfully!" );
     $c->res->redirect( $c->uri_for( $self->action_for('index') ) );

}


=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

	   This library is free software. You can redistribute it and/or modify
	   it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
