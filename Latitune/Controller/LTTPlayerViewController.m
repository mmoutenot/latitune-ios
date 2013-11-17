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
    UIBackgroundTaskIdentifier bgTaskId;
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

- (void) awakeFromNib
{
    bgTaskId = UIBackgroundTaskInvalid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Rdio *rdio = [(LTTAppDelegate *)[[UIApplication sharedApplication] delegate] rdio];
    player = rdio.player;
    player.delegate = self;
    [[LTTCommunication sharedInstance] getBlipsWithDelegate:self];
    // Observe changes to the 'currentTrack' of the player
    [player addObserver:self
             forKeyPath:@"currentTrack"
                options:NSKeyValueObservingOptionNew context:nil];
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

#pragma mark Play background music

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    // When the current track changes, create a new background task and end
    // the previous task
    if ([keyPath isEqualToString:@"currentTrack"]) {
        UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
        newTaskId = [[UIApplication sharedApplication]
                     beginBackgroundTaskWithExpirationHandler:NULL];
        if (bgTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
        }
        
        bgTaskId = newTaskId;
    }
}

@end
