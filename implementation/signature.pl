use strict;
use warnings;
use SDL;
use Cwd;
use SDL::Event;
use SDLx::App;

my $app = SDLx::App->new( w => 600, h => 480, d => 32, title => "Simple Paint");
sub quit_event {

    my $event = shift;
    my $controller = shift;
    $controller->stop if $event->type == SDL_QUIT;

}


$app->draw_rect( [0,0,$app->w, $app->h], [255,255,255,255] );


sub under_treshold
{
    my( $x,$y, $a,$b) = @_;

    my $dist = sqrt( ($x-$a)**2 + ($y-$b)**2);

    return ($dist < 50);

}

my $drawing = 0;
my $previous;
sub mouse_event {

    my $event = shift;

    if($event->type == SDL_MOUSEBUTTONDOWN || $drawing)
    {

        $drawing = 1;
        my $x =  $event->button_x;
        my $y =  $event->button_y;

        if ( $previous )
        {
        
            if( under_treshold( $previous->[0], $previous->[1], $x, $y ) )
            {
                $app->draw_line( [$x,$y], $previous,  [0,0,0,255] )
            }    
            else { $previous = undef;  return; }

        }
        $previous= [$x,$y];
        $app->update();
    }
    $drawing = 0 if($event->type == SDL_MOUSEBUTTONUP );
}


sub save_image {

   if( SDL::Video::save_BMP( $app, 'painted.bmp' ) == 0 && -e 'painted.bmp')
    {
         warn 'Saved painted.bmp to '.cwd();
    }
    else 
    {
        warn 'Could not save painted.bmp: '.SDL::get_errors();
    }

}


sub keyboard_event {

    my $event = shift;
    my $controller = shift;
    if ( $event->type == SDL_KEYDOWN )
    {
        my $key_name = SDL::Events::get_key_name( $event->key_sym );

        my $mod_state = SDL::Events::get_mod_state();        
        save_image if $key_name =~ /^s$/ && ($mod_state & KMOD_CTRL); 

        $app->draw_rect( [0,0,$app->w, $app->h], [255,255,255,255] ) if $key_name =~ /^c$/;
        $controller->stop() if $key_name =~ /^q$/
    }
        $app->update();
    return 1;
}


$app->add_event_handler( \&quit_event );
$app->add_event_handler( \&mouse_event );
$app->add_event_handler( \&keyboard_event );
$app->run();


