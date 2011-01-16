package SIMS::Controller::Helper;
use strict;
use warnings;
use Email::Simple::Creator;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP::TLS;
use Try::Tiny;
use namespace::autoclean;

sub send_email {
	my( $to, $subject, $body) = @_;

	my $transport = email_transport();

    my $message = Email::Simple->create(
        header => [
            From    => 'western.graduate.sims@gmail.com',
            To      => $to,
            Subject => $subject
        ],
        body => $body
    );
		die "Transport not created" unless $transport;
		die "Message creation failed" unless $message;
        sendmail( $message, { transport => $transport } );
}

sub email_transport
{

    my $transport = Email::Sender::Transport::SMTP::TLS->new(
        host     => 'smtp.gmail.com',
        port     => 587,
        username => 'western.graduate.sims@gmail.com',
        password => 'graduateSIMS',
        helo     => 'SIMSdb'
    );

	return $transport;

}

sub random_confirm_key
{

	return _rand_string(32);

}

sub random_password
{

	return _rand_string();

}


sub _rand_string
{
	my $length = shift;
	$length = 8 unless $length;
    my @password_set = ( ( "a" ... "z" ), ( "A" ... "Z" ), ( 0 ... 9 ) );

    #Generate a random password
    my $password = '';
    $password .= $password_set[ rand() * $#password_set ] foreach ( 0 ... $length );
	return $password;
}

1;
