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

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
// Do any additional setup after loading the view.
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)dropButton:(id)sender {
  LTTSong *song = [self getCurrentExternalSong];
  if (song) {
    [song populateEchonestIDWithDelegate:self];
  } else {
    NSString *alertMessage = NO_SONG_ALERT_MESSAGE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NO_SONG_ALERT_TITLE
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
  }
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
  if (title) {
    return [[LTTSong new] initWithTitle:title artist:artist album:album];
  } else {
    return nil;
  }
}

#pragma callbacks
- (void) populateEchonestIDSucceededForSong:(LTTSong *)song{
  [[LTTCommunication sharedInstance] addSong:song withDelegate:self];
}

- (void) populateEchonestIDFailed {
  NSLog(@"Populate echonest id failed");
}

-(void) addSongDidFailWithError:(NSNumber *)errorCode {
  NSLog(@"Adding song failed: %@", errorCode);
}

-(void) addSongDidSucceedWithSong:(LTTSong *)song {
  CLLocationCoordinate2D loc = self.locationManager.location.coordinate;
  [[LTTCommunication sharedInstance] addBlipWithSong:song atLocation:loc withDelegate:self];
}

-(void) addBlipDidFailWithError:(NSNumber *)errorCode {
  NSLog(@"Adding blip failed: %@", errorCode);
}

-(void) addBlipDidSucceedWithBlip:(LTTBlip *)blip {
  NSLog(@"Blip added successfully");
}

@end
