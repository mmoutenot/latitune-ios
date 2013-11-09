//
//  LTTRadarViewController.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import "LTTRadarViewController.h"

@implementation LTTRadarViewController

@synthesize locationManager;
@synthesize compassImage;

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
  
  // initialize our geolocation and start updating
  locationManager = [[CLLocationManager alloc] init];
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.headingFilter = 1;
  locationManager.delegate=self;
  [locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
  compassImage.center = CGPointMake(160, 167);
  
  // Convert Degree to Radian and move the needle
  float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
  float newRad = -newHeading.trueHeading * M_PI / 180.0f;
  
  [UIView animateWithDuration:0.2 animations:^{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    rotationAnimation.toValue=[NSNumber numberWithFloat:newRad];
    rotationAnimation.duration = 0.2;
    [compassImage.layer addAnimation:rotationAnimation forKey:@"AnimateFrame"];
  }];

  
  NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
