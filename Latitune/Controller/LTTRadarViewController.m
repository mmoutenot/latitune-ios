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
  self.radarView = [[LTTRadarView alloc] init];

  self.radarView.frame = self.view.frame;
  
  self.bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar-bg"]];
  self.bgView.contentMode = UIViewContentModeCenter;
  
  [self.radarView addSubview:self.bgView];
  [self.view addSubview:self.radarView];
  
  self.radarView.center = self.view.center;
  self.bgView.center = self.view.center;
  
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

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
  
  // Convert Degree to Radian and move the needle
//  float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
  float newRad = -newHeading.trueHeading * M_PI / 180.0f;
  NSLog(@"%f", newRad);
//  CGAffineTransform rotationTransform = CGAffineTransformRotate(self.radarView.transform, newRad-oldRad);
  
  [UIView animateWithDuration:0.2
    animations:^{
      CGAffineTransform  xform = CGAffineTransformMakeRotation(newRad);
      self.view.transform = xform;
      [self.radarView setNeedsDisplay];
      [self.view setNeedsDisplay];
    } completion:^(BOOL finished){
      NSLog(@"Image: %f, %f, %f, %f", self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
      NSLog(@"Radar: %f, %f, %f, %f", self.radarView.frame.origin.x, self.radarView.frame.origin.y, self.radarView.frame.size.width, self.radarView.frame.size.height);
      NSLog(@"Super: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
