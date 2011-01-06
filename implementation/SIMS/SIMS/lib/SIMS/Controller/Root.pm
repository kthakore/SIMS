package SIMS::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

SIMS::Controller::Root - Root Controller for SIMS

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	my @roles = $c->user->roles();

	my $dashboard = [];
	
	if( grep /(g_admin|g_exec|adv_com|fac)/, @roles )
	{
		push (@{$dashboard}, { src => $c->uri_for('faculty'), text => 'Manage Students' });
	}
	$c->stash->{dashboard} = $dashboard;

}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'page not found' );
    $c->response->status(404);
}

sub unauthorized :Chained('/') :PathPart('unauthorized') :Args(0)  {
    my ( $self, $c ) = @_;
    $c->response->body( 'You are not authorized for this page: '.$c->session->{original_URI} );
   $c->response->status(200);

}


=head2 auto

Check if there is a user and, if not, forward to login page

=cut

    # Note that 'auto' runs after 'begin' but before your actions and that
    # 'auto's "chain" (all from application path to most specific class are run)
    # See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.
    sub auto :Private {
        my ($self, $c) = @_;

        # Allow unauthenticated users to reach the login page.  This
        # allows unauthenticated users to reach any action in the Login
        # controller.  To lock it down to a single action, we could use:
        #   if ($c->action eq $c->controller('Login')->action_for('index'))
        # to only allow unauthenticated access to the 'index' action we
        # added above.
        if ($c->controller eq $c->controller('Login')) {
            return 1;
        }

        # If a user doesn't exist, force login
        if (!$c->user_exists) {
            # Dump a log message to the development server debug output
            $c->log->debug('***Root::auto User not found, forwarding to /login');
			# Save where we care coming from
			# $c->flash->{came_from} = 
			$c->session->{original_URI} = $c->request->uri unless( $c->request->uri =~ /static/ );
            # Redirect the user to the login page
            $c->response->redirect($c->uri_for('/login'));
            # Return 0 to cancel 'post-auto' processing and prevent use of application
            return 0;
        }

        # User found, so return 1 to continue with processing after this 'auto'
        return 1;
    }


=head2 end

Attempt to render a view, if needed.

=cut

sub base : Chained('/') CaptureArgs(0) PathPart('') {}

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
