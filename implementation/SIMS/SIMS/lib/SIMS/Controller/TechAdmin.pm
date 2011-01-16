package SIMS::Controller::TechAdmin;
use Moose;
use Try::Tiny;
use Email::Simple::Creator;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP::TLS;
use SIMS::Controller::Helper;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::TechAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.



=head1 METHODS

=cut

=head2 base 
Check if the user is a tech admin

=cut

sub base : Chained('/') PathPart('techadmin') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my @roles = $c->user->roles();
    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( grep /^t_admin|g_admin$/, @roles );
}

=head2 index

=cut

sub index : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{roles} = $c->model('DB::Role');
    $c->stash->{users} = $c->model('DB::User');

    #	$c->response->body('Matched SIMS::Controller::TechAdmin in TechAdmin.');
}

sub create : Chained('base') PathPart('create') Args(0) {
    my ( $self, $c ) = @_;

    #Validation of the email?

    my $message = '';
    try {
        my $user = $c->model('DB::User')->create(
            {
                username      => $c->req->param('username'),
                password      => $c->req->param('password'),
                email_address => $c->req->param('email_address'),

            }
        );

        #	$user->add_to_user_roles( role_id => $c->req->param('role_id') );
        $user->create_related( 'user_roles',
            { role_id => $c->req->param('role_id') } );

        $message = 'User ' . $user->id . ' created';

        my @roles = $user->roles();
        foreach (@roles) {
            $_ = $_->role();
        }
        if ( grep /^student$/, @roles ) {
            my($m, $student) = $self->_create_student( $c, $user)
        }
		
    }
    catch {
        $message = 'Cannot make user: ' . $_;
    };

    $c->flash( message => $message );
    $c->res->redirect( $c->uri_for( $self->action_for('index') ) );

}

sub update_pass : Chained('base') PathPart('update_pass') Args(0) {
    my ( $self, $c ) = @_;

    my $user_id = $c->req->param('id');
    _create_send_password( @_, $user_id );
}

sub _create_send_password {
    my ( $self, $c, $user_id ) = @_;

	my $password = SIMS::Controller::Helper::random_password();
	
    #Update the field on the user's account
    my $user = $c->model('DB::User')->find($user_id);

    #Email it to the user's email    
	try {

		SIMS::Controller::Helper::send_email( $user->email_address(), 'Email has been changed',   "Your new password is $password, for the account "
          . $user->username() . "." );


        $c->log->debug("***User setting pasword $password ");
        $user->update( { password => $password } );
        $c->flash( message => "User $user_id password  updated successfully!" );
    }
    catch {
        $c->flash( message => "Cannot Update Password for user. $_ " );
    };
    $c->res->redirect( $c->uri_for( $self->action_for('index') ) );

}

sub _create_student {
my($self, $c, $user) = @_;
            my $student = $c->model('DB::Student')->create(
                {
                    name    => $c->req->param('username'),
                    user_id => $user->id,
                }
            );
           
	return ('<br /> Student ' . $student->id . ' created', $student );
 
}
=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

	   This library is free software. You can redistribute it and/or modify
	   it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
