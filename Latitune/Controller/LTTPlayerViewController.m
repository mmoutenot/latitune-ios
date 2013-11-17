//
//  LTTPlayerViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTPlayerViewController.h"
#import "LTTAppDelegate.h"
#import <Rdio/Rdio.h>
#import "LTTSongProvider.h"
#import "LTTCommunication.h"

@interface LTTPlayerViewController () <RDPlayerDelegate, GetBlipsDelegate>
{
    bool playing, paused;
    RDPlayer *player;
}

@end

@implementation LTTPlayerViewController

@synthesize artistLabel, albumLabel, trackLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Rdio *rdio = [(LTTAppDelegate *)[[UIApplication sharedApplication] delegate] rdio];
    player = rdio.player;
    player.delegate = self;
    [[LTTCommunication sharedInstance] getBlipsWithDelegate:self];
    //[player queueSource:@"t2278209"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playPause:(id)sender
{
    if (!playing)
    {
        [player play];
    } else
    {
        [player togglePause];
    }
}

- (void) playSong:(LTTSong *)song
{
    bool canPlay = false;
    for (LTTSongProvider *songprovider in song.providers) {
        if (songprovider.provider == ProviderRdio)
        {
            [player playSource:songprovider.providerKey];
            canPlay = true;
            break;
        }
    }
    if (!canPlay)
    {
        return;
    }
    [artistLabel setText:[song artist]];
    [albumLabel setText:[song album]];
    [trackLabel setText:[song title]];
    [player play];
    
}

#pragma mark RDPlayerDelegate

- (BOOL)rdioIsPlayingElsewhere
{
    // let the Rdio framework tell the user.
    return NO;
}

- (void)rdioPlayerChangedFromState:(RDPlayerState)fromState toState:(RDPlayerState)state
{
    playing = (state != RDPlayerStateInitializing && state != RDPlayerStateStopped);
    paused = (state == RDPlayerStatePaused);
}

#pragma mark GetBlipsDelegate

- (void)getBlipsDidSucceedWithBlips:(NSArray *)blips
{
    LTTBlip *blip = [blips lastObject];
    [self playSong:blip.song];
    NSLog(@"%@",blip.song);
    NSLog(@"%@",blip.song.providers);
}

- (void)getBlipsDidFail
{
    NSLog(@"getBlipdsFailed");
}

@end
