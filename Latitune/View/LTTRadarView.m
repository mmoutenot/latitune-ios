//
//  LTTRadarView.m
//  Latitune
//
//  Created by alden on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTRadarView.h"

#define VIEWABLE_AREA_METERS 500 // x/y physical distance viewable on radar

// At latitude lat, how many meters is one degree of longitude or latitude? [via wikipedia]
#define metersPerLatAt(lat) (111132.954 - (559.822 * cos(2.0*(lat))) + (1.175 * cos(4.0*(lat))))
#define metersPerLngAt(lat) ((M_PI/180) * 6367449 * cos(lat))

@interface LTTRadarView ()

@property (nonatomic) CLLocation *location;
@property (nonatomic) NSArray *blips;
@property (nonatomic) NSMutableDictionary *blipIDToView;

@end

@implementation LTTRadarView

- (LTTRadarView *)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  return [self initialze];
}

- (LTTRadarView *)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  return [self initialze];
}

- (LTTRadarView *)initialze
{
  if (self) {
    _blipIDToView = [NSMutableDictionary dictionary];
    _blips = @[];
    CLLocationCoordinate2D coord;
    coord.latitude = 90.5;
    coord.longitude = -40.7;
    CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coord altitude:1000.0 horizontalAccuracy:100 verticalAccuracy:100 course:5 speed:5 timestamp:nil];
    [self setCenterLocation: loc];
  }
  return self;
}

- (void)setCenterLocation:(CLLocation *)location {
  _location = location;
  
  [self updateBlipViewLocations];
}

- (void)addBlips:(NSArray *)blips {
  _blips = [_blips arrayByAddingObjectsFromArray:blips];
  for (LTTBlip *blip in _blips) {
    CGRect viewRect = CGRectMake(0, 0, 40, 40);
    LTTBlipView *blipView = [[LTTBlipView alloc] initWithFrame:viewRect];
    blipView.layer.opacity = 0.f;
    [blipView setBlip:blip];
    [self addSubview:blipView];
    [self bringSubviewToFront:blipView];
    [_blipIDToView setObject:blipView forKey:@(blip.blipID)];
    
    // animate fade in and grow
    [UIView animateWithDuration:1.5f animations:^{
      blipView.layer.opacity = 1.f;
    }];
  }
  [self updateBlipViewLocations];
}

- (void)updateBlipViewLocations {
  if (!_blips || !_location) return;
  for (LTTBlip *blip in _blips) {
    LTTBlipView *blipView = [_blipIDToView objectForKey:@(blip.blipID)];
    // TODO animate it real fancy like
    blipView.center = [self getCenterPointForBlip:blip];
  }
}

- (void) rotateBlipViews:(NSNumber *)rad {
  for (LTTBlip *blip in _blips) {
    LTTBlipView *blipView = [_blipIDToView objectForKey:@(blip.blipID)];
    [UIView animateWithDuration:0.5 animations:^{
      CGAffineTransform  xform = CGAffineTransformMakeRotation(rad.floatValue);
      blipView.transform = xform;
      [self setNeedsDisplay];
      [blipView setNeedsDisplay];
    } completion:^(BOOL finished){
    }];
  }
}

- (CGPoint)getCenterPointForBlip:(LTTBlip *)blip {
  CLLocation *blipLocation = [[CLLocation alloc] initWithLatitude:blip.lat longitude:blip.lng];
  CGVector screenDistances = [self getVectorBetweenCenterAndLocation:blipLocation];
  double halfWidth = self.frame.size.width / 2;
  double halfHeight = self.frame.size.height / 2;
  double yPosition = (self.frame.size.height - (screenDistances.dy + halfHeight)); // convert to upper left based coordinate system
  double xPosition = screenDistances.dx + halfWidth;
  return CGPointMake(xPosition, yPosition);
}

- (CGVector)getVectorBetweenCenterAndLocation:(CLLocation *)location {
  return [self getVectorBetweenLocation:_location andLocation:location];
}

// Returns the screen point (pixel) dx and dy between the two geographic locations
- (CGVector) getVectorBetweenLocation:(CLLocation *)l1 andLocation:(CLLocation *)l2 {
  double lat = l1.coordinate.latitude;
  double dMetersLat = (l2.coordinate.latitude - l1.coordinate.latitude) * metersPerLatAt(lat);
  double dMetersLng = (l2.coordinate.longitude - l1.coordinate.longitude) * metersPerLngAt(lat);
  double longSide = MAX(self.frame.size.height, self.frame.size.width);
  double pointsPerMeter = longSide/VIEWABLE_AREA_METERS;
  return CGVectorMake(dMetersLat * pointsPerMeter, dMetersLng * pointsPerMeter);
}


@end
