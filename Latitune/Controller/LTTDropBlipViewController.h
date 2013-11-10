//
//  LTTDropBlipViewController.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LTTDropBlipViewController : UIViewController <AddBlipDelegate, AddSongDelegate, CLLocationManagerDelegate, LTTSongDelegate>

- (IBAction)dropButton:(id)sender;
- (void) populateEchonestIDSuccessWithSong:(LTTSong *)song;

@property (nonatomic,retain) CLLocationManager *locationManager;

@end
