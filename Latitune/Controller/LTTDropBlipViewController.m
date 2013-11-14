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
      self.locationManager = [[CLLocationManager alloc] init];
      self.locationManager.delegate = self;
      self.locationManager.distanceFilter = kCLDistanceFilterNone;
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      [self.locationManager startUpdatingLocation];
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
  LTTSong *song = [self getCurrentExternalSong];
  [song populateEchonestIDWithDelegate:self];
}

- (LTTSong *)getCurrentExternalSong {
  NSString *title;
  NSString *artist;
  NSString *album;

  MPMediaItem* currentPlaying = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];

  title = [currentPlaying valueForProperty:MPMediaItemPropertyTitle];
  album = [currentPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
  artist = [currentPlaying valueForProperty:MPMediaItemPropertyArtist];

  /*
   // THIS LOGIC DOES NOT WORK TO GET RDIO/SPOTIFY NOW PLAYING SONGS

  NSDictionary* currentPlayingRdio = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
  NSLog(@"%@", currentPlayingRdio);

  if (!title || !artist) { // iPodMusicPlayer may not be playing anything. Let's defer to Rdio.

    Rdio *rdio = ((LTTAppDelegate *)[[UIApplication sharedApplication] delegate]).rdio;
    [rdio callAPIMethod:@"" withParameters:<#(NSDictionary *)#> delegate:<#(id<RDAPIRequestDelegate>)#>]
    NSLog(@"%@", );
  }
   */
  LTTSong* song = [[LTTSong new] initWithTitle:title artist:artist album:album];
  return song;
}

#pragma callbacks
- (void) populateEchonestIDSucceededForSong:(LTTSong *)song{
  [[LTTCommunication sharedInstance] addSong:song withDelegate:self];
}

-(void) addSongDidFail {
  NSLog(@"Adding song failed");
}

-(void) addSongDidSucceedWithSong:(LTTSong *)song {
  CLLocationCoordinate2D loc = self.locationManager.location.coordinate;
  [[LTTCommunication sharedInstance] addBlipWithSong:song atLocation:loc withDelegate:self];
}

-(void) addBlipDidFail {
  NSLog(@"Adding blip failed");
}

-(void) addBlipDidSucceedWithBlip:(LTTBlip *)blip {
  NSLog(@"Blip added successfully");
}

@end
