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
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.headingFilter = 1;
  self.locationManager.delegate=self;
  [self.locationManager startUpdatingHeading];
  [self.locationManager startUpdatingLocation];
}

// Allow adding a just created blip to the radar
- (void)addBlip:(LTTBlip *)blip {
  self.blips = [self.blips arrayByAddingObject:blip];
  [self.radarView setBlips:self.blips];
}

#pragma mark - Get Blip Delegate

- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {
  [self.radarView setBlips:blips];
}

- (void) getBlipsDidFail {
  // not cool man
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *previousLocation = self.currentLocation;
  self.currentLocation = [locations lastObject];
  if (!previousLocation || [previousLocation distanceFromLocation:self.currentLocation] > 100) {
    [[LTTCommunication sharedInstance] getBlipsNearLocation:self.currentLocation.coordinate withDelegate:self];
  }
  [self.radarView setCenterLocation:self.currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  float newRad = -newHeading.trueHeading * M_PI / 180.0f;
  
  [UIView animateWithDuration:0.2
    animations:^{
      CGAffineTransform  xform = CGAffineTransformMakeRotation(newRad);
      self.view.transform = xform;
      [self.radarView setNeedsDisplay];
      [self.view setNeedsDisplay];
    } completion:^(BOOL finished){
    }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
