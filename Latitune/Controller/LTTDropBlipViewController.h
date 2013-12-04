//
//  LTTDropBlipViewController.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

NSString *NO_SONG_ALERT_MESSAGE = @"Latitune can't connect to the tunes! ";
NSString *NO_SONG_ALERT_TITLE = @"Give us a tune!";

@interface LTTDropBlipViewController : UIViewController <AddBlipDelegate, AddSongDelegate, CLLocationManagerDelegate, LTTSongDelegate>

- (IBAction)dropButton:(id)sender;

@property (nonatomic,retain) CLLocationManager *locationManager;

@end
