package SIMS;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
	StackTrace
	Authentication
	Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in sims.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'SIMS',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);

# Configure the SimpleDB Autentication for Catalyst::Plugin::Authentication
__PACKAGE__->config->{'Plugin::Authentication'} = {
		default => {
			class           => 'SimpleDB',
			user_model      => 'DB::User',
			password_type   => 'self_check',
		},
	};

# Start the application
__PACKAGE__->setup();


=head1 NAME

SIMS - Catalyst based application

=head1 SYNOPSIS

    script/sims_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<SIMS::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
