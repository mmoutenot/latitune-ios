//
//  LTTDropBlipViewController.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import <Rdio/Rdio.h>
#import "LTTCommunication.h"

#import "LTTSong.h"
#import "LTTAppDelegate.h"
#import "LTTDropBlipViewController.h"

@implementation LTTDropBlipViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dropButton:(id)sender {
  [self getCurrentExternalSong];
}

- (LTTSong *)getCurrentExternalSong {
  NSString *title;
  NSString *artist;
  NSString *album;
  
  MPMediaItem* currentPlaying = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
  
  title = [currentPlaying valueForProperty:MPMediaItemPropertyTitle];
  album = [currentPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
  artist = [currentPlaying valueForProperty:MPMediaItemPropertyArtist];
  
//  NSDictionary* currentPlayingRdio = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
//  NSLog(@"%@", currentPlayingRdio);

//  if (!title || !artist) { // iPodMusicPlayer may not be playing anything. Let's defer to Rdio.

//    Rdio *rdio = ((LTTAppDelegate *)[[UIApplication sharedApplication] delegate]).rdio;
//    [rdio callAPIMethod:@"" withParameters:<#(NSDictionary *)#> delegate:<#(id<RDAPIRequestDelegate>)#>]
//    NSLog(@"%@", );
//  }
  
  
  LTTSong* song = [[LTTSong new] initWithTitle:title artist:artist album:album];
  return song;
}

@end
