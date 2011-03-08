package SIMS::Controller::Meeting;
use Moose;
use Try::Tiny;
use JSON;
use Cwd 'abs_path';
use SDL;
use SDLx::App;
use SDL::Video;
use SIMS::Controller::Helper;
use namespace::autoclean;
use DateTime::Format::DateParse;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SIMS::Controller::Meeting - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/') PathPart('meeting') CaptureArgs(1) {
    my ( $self, $c, $m_id ) = @_;

    $c->session->{original_URI} = $c->request->uri;
    my $id = $c->user->id;

    $c->log->debug("Searching for $m_id");
    my $meeting = $c->model('DB::Meeting')->find($m_id);
    unless ( defined $meeting ) {
        $c->response->redirect( $c->uri_for('/default') );
    }
    else {
        my @advisors = $meeting->meeting_advisors();
        my @advisors_id;
        push( @advisors_id, $_->advisor_id() ) foreach (@advisors);

        $c->log->debug(
            "Student id is " . $meeting->student_id() . "and user id" . $id );
        $c->response->redirect( $c->uri_for('/unauthorized') )
          unless (
            $meeting->student() && $meeting->student()->user_id() == $id
            || grep /$id/,
            @advisors_id
          );

        my @c = $meeting->meeting_comments();
        my @comments;
        my @recommendations;

        foreach (@c) {
            if ( $_->type() eq 'comment' ) {
                push @comments, $_;
            }
            else {
                push @recommendations, $_;
            }
        }

        $c->stash( advisors        => \@advisors );
        $c->stash( comments        => \@comments );
        $c->stash( recommendations => \@recommendations );

    }

    $c->stash( meeting => $meeting );

    unless ( $c->stash->{possible_advisors} ) {
        my $adv = $c->model('DB::User')->faculty_users();
        $c->stash->{possible_advisors} = $adv;
    }

    $c->stash->{assign_advisor_url} =
      $c->uri_for('/meeting') . "/$m_id/assign_advisor";

}

sub pdf : Chained('base') : PathPart('pdf') : Args(0) {
    my ( $self, $c ) = @_;

    my $uri_img = _create_jpeg_sign( $c->stash->{meeting}->student_sign() );
    $c->stash->{student_sign_jpeg} = $uri_img;
    $c->log->debug( "Made " . $uri_img );
    $c->stash->{pdf_template} = 'hello_pdf.tt';
    $c->forward('View::PDF::Reuse');

}

sub cancel : Chained('base') : PathPart('cancel') : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{meeting}->delete();
    $c->response->redirect('/');
}

sub assign_advisor : Chained('base') : PartPart('assign_advisor') : Args(1) {
    my ( $self, $c, $id ) = @_;

    my $new_meeting_adv;
    my $new_meeting_confirm;
    try {
        my $user_m =
          $c->model('DB::MeetingAdvisor')
          ->find( $c->stash->{meeting}->id(), $id );
        unless ($user_m) {
            my $user = $c->model('DB::User')->find($id);
            my $new_meeting_adv =
              $c->stash->{meeting}->create_related( 'meeting_advisors',
                { advisor_id => $user->id() } );
            $c->stash->{message} = "Added Advisor";

            #making a confirmation record
            $new_meeting_confirm = $c->model('DB::MeetingConfirmation')->create(
                {
                    key     => SIMS::Controller::Helper::random_confirm_key(32),
                    status  => 'Just added',
                    details => ''
                }
            );
            $new_meeting_adv->update(
                { confirmation => $new_meeting_confirm->id() } );

            SIMS::Controller::Helper::send_email(
                $user->email_address(),
                "Confirmation required for meeting ",
                "Log in and Confirm your attendence at "
                  . $c->uri_for('/')
                  . 'meeting/'
                  . $c->stash->{meeting}->id()
                  . '/confirm/'
                  . $new_meeting_confirm->key()
            );

        }
        else {
            $c->stash->{message} = "Advisor already added";
        }

        # Make a confirmation and send an email

    }
    catch {
        if ($new_meeting_adv) {
            $new_meeting_adv->delete();
        }
        $c->stash->{message} = "Problem: $_";
    };

    $c->stash->{template} = 'meeting/index.tt';
}

sub update : Chained('base') : PathPart('update') : Args(0) {

    my ( $self, $c ) = @_;

    if ( $c->req->param('meeting_up_submit') ) {

        my $date = DateTime::Format::DateParse->parse_datetime(
            $c->req->param('meeting_date') );

        try {

            $c->stash->{meeting}->update(
                {
                    datetime    => $date,
                    description => $c->req->param('meeting_desc'),
                    progress    => $c->req->param('progress')
                }
            );

            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {
            $c->stash->{message} = "problem $_";
        };
    }
    $c->stash( template => 'meeting/index.tt' );
}

sub confirm : Chained('base') : PathPart('confirm') : Args(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash->{confirmation} =
      $c->model('DB::MeetingConfirmation')->search( { key => $id } )->single();
    my $advisor = $c->stash->{confirmation}->meeting_advisors()->single();

    $c->response->redirect( $c->uri_for('/unauthorized') )
      unless ( $c->user->id == $advisor->advisor_id() );

    $c->stash->{confirm_url} =
        $c->uri_for('/')
      . 'meeting/'
      . $c->stash->{meeting}->id()
      . '/confirm/'
      . $c->stash->{confirmation}->key();

    if ( $c->req->param('submit_confirm') ) {

        $c->stash->{confirmation}->update(
            {
                status  => $c->req->param('status'),
                details => $c->req->param('details')
            }

        );

    }

}

sub add_comment : Chained('base') : PathPart('add_comment') : Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->req->param('submit_comment') ) {

        try {

            my $comment = $c->model('DB::MeetingComment')->create(
                {
                    meeting_id   => $c->stash->{meeting}->id(),
                    commenter_id => $c->user->id(),
                    comment      => $c->req->param('comment'),
                    type         => $c->req->param('type')
                }
            );

            $c->stash( message => 'Added comment ' . $comment->id() );

            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {
            $c->stash( message => "Problem $_" );
        };

    }

    $c->stash( template => 'meeting/index.tt' );

}

sub delete_comment : Chained('base') : PathPart('delete_comment') : Args(1) {
    my ( $self, $c, $id ) = @_;
    $c->response->body('Deleting Comments');

}

sub student_sign : Chained('base') PathPart('student_sign') Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->stash->{meeting}->student->user_id() == $c->user->id() ) {
        try {
            $c->stash->{meeting}
              ->update( { student_sign => $c->req->param('output') } );
            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {

            $c->stash( message => "Problem $_" );
        };
    }
    $c->stash( template => 'meeting/index.tt' );

}

sub student_unsign : Chained('base') PathPart('student_unsign') Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->stash->{meeting}->student->user_id() == $c->user->id() ) {
        try {
            $c->stash->{meeting}->update( { student_sign => '' } );
            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {

            $c->stash( message => "Problem $_" );
        };
    }
    $c->stash( template => 'meeting/index.tt' );

}

sub advisor_sign : Chained('base') : PathPart('advisor_sign') : Args(1) {
    my ( $self, $c, $id ) = @_;

    my $meeting_advisor =
      $c->model('DB::MeetingAdvisor')->find( $c->stash->{meeting}->id(), $id );
    if ( $meeting_advisor && $meeting_advisor->advisor_id() == $c->user->id() )
    {
        try {
            $meeting_advisor->update(
                { signature => $c->req->param('output') } );
            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {

            $c->stash( message => "Problem $_" );
        };
    }
    $c->stash( template => 'meeting/index.tt' );
}

sub advisor_unsign : Chained('base') : PathPart('advisor_unsign') : Args(1) {
    my ( $self, $c, $id ) = @_;

    my $meeting_advisor =
      $c->model('DB::MeetingAdvisor')->find( $c->stash->{meeting}->id(), $id );
    if ( $meeting_advisor && $meeting_advisor->advisor_id() == $c->user->id() )
    {
        try {
            $meeting_advisor->update( { signature => '' } );

            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() );

        }
        catch {

            $c->stash( message => "Problem $_" );
        };
    }
    $c->stash( template => 'meeting/index.tt' );

}

sub edit_comment : Chained('base') : PathPart('edit_comment') : Args(0) {
    my ( $self, $c, $id ) = @_;

    $id = $c->req->param('submit_comment');
    if ($id) {

        try {
            my $comment = $c->model('DB::MeetingComment')->find($id);
            die "No such comment" unless $comment;
            die "Cannot edit comment that is not made by you!"
              unless $comment->commenter_id() == $c->user->id();

            $comment->update( { comment => $c->req->param('comment') } );

            $c->response->redirect(
                $c->uri_for('/') . 'meeting/' . $c->stash->{meeting}->id() )

        }
        catch {
            $c->stash( message => "Problem $_" );
        };
    }
    $c->stash( template => 'meeting/index.tt' );

}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

}

sub _create_jpeg_sign {
    my $json_string = shift || '[{"lx":0,"ly":10,"mx":200,"my":10}]';
    my $videodriver = $ENV{SDL_VIDEODRIVER};
    $ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

    my $app = SDLx::App->new( width => 200, height => 50, init => SDL_INIT_VIDEO);
    $app->draw_rect( [ 0, 0, $app->w, $app->h ], 0xFFFFFFFF );
    my $sign = decode_json($json_string);

    foreach (@$sign) {
        $app->draw_line( [ $_->{lx}, $_->{ly} ],
            [ $_->{mx}, $_->{my} ], 0x0000DDFF );
    }

    $app->update();
    my $rand;
    map { $rand .= ( "a" .. "z" )[ rand 26 ] } 1 .. 8;
    my $rand_pic = 'sign' . $rand;

    my $dir = '/tmp/sign/';
    mkdir $dir unless -d $dir;

    SDL::Video::save_BMP( $app, $dir . $rand_pic . '.bmp' );

    `mogrify -format jpg $dir$rand_pic.bmp `;

    #reset the old video driver
    if ($videodriver) {
        $ENV{SDL_VIDEODRIVER} = $videodriver;
    }
    else {
        delete $ENV{SDL_VIDEODRIVER};
    }

    return abs_path( $dir . $rand_pic . '.jpg' );

}

=head1 AUTHOR

Kartik Thakore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
