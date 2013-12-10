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

// Allow adding a just created blip to the radar
- (void)addBlip:(LTTBlip *)blip {
  _blips = [_blips arrayByAddingObject:blip];
  [_radarView setBlips:_blips];
}

#pragma mark - Get Blip Delegate

- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {
  [_radarView setBlips:blips];
}

- (void) getBlipsDidFailWithError:(NSNumber *)errorCode {
  // not cool man
  NSLog(@"get blips did fail: %@", errorCode);
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *previousLocation = _currentLocation;
  _currentLocation = [locations lastObject];
  if (!previousLocation || [previousLocation distanceFromLocation:_currentLocation] > 100) {
    [[LTTCommunication sharedInstance] getBlipsNearLocation:self.currentLocation.coordinate withDelegate:self];
  }
  [_radarView setCenterLocation:_currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  NSNumber *rad = [NSNumber numberWithFloat:(-newHeading.trueHeading * M_PI / 180.0f)];
  [_radarView performSelectorOnMainThread:@selector(rotate:) withObject:rad waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
