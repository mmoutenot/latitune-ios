//
//  LTTRadarViewController.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import "LTTRadarViewController.h"

@implementation LTTRadarViewController

# pragma mark - Init / Load

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
  
  // initialize our geolocation and start updating
  _locationManager = [[CLLocationManager alloc] init];
  _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  _locationManager.headingFilter = 1;
  _locationManager.delegate = self;
  [_locationManager startUpdatingHeading];
  [_locationManager startUpdatingLocation];
}

#pragma mark - Get Blip Delegate

- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {
  [_radarView addBlips:blips];
}

- (void) getBlipsDidFail {
  // not cool man
}

#pragma mark - Add Blip Delegate

-(void) addBlipDidFail {
  NSLog(@"Adding blip failed");
}

-(void) addBlipDidSucceedWithBlip:(LTTBlip *)blip {
  [_radarView addBlips:@[blip]];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *previousLocation = _currentLocation;
  _currentLocation = [locations lastObject];
  if (!previousLocation || [previousLocation distanceFromLocation:_currentLocation] > 100) {
    [[LTTCommunication sharedInstance] getBlipsNearLocation:_currentLocation.coordinate withDelegate:self];
  }
  [_radarView setCenterLocation:_currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  NSNumber *rad = [NSNumber numberWithFloat:(-newHeading.trueHeading * M_PI / 180.0f)];
  [self rotateRadarView:rad];
}

// rotates view by rad. Also roates blip subviews the negative amount
- (void)rotateRadarView:(NSNumber *) rad {
  [UIView animateWithDuration:0.5 animations:^{
    CGAffineTransform  xform = CGAffineTransformMakeRotation(rad.floatValue);
    self.view.transform = xform;
    [self.radarView setNeedsDisplay];
    [self.view setNeedsDisplay];
  } completion:^(BOOL finished){
  }];
  [_radarView rotateBlipViews: [NSNumber numberWithFloat:rad.floatValue * -1]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
