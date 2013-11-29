//
//  LTTRadarViewController.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "LTTCommunication.h"
#import "LTTRadarView.h"
#import "LTTBlip.h"

@interface LTTRadarViewController : UIViewController <CLLocationManagerDelegate, GetBlipsDelegate>

@property (weak, nonatomic) IBOutlet LTTRadarView *radarView;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *blips;

- (void)addBlip:(LTTBlip *)blip;

@end