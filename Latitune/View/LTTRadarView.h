//
//  LTTRadarView.h
//  Latitune
//
//  Created by alden on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LTTBlipView.h"
#import "LTTBlip.h"

// A view which displays nearby blips as if looking down on a radar screen
@interface LTTRadarView : UIView

- (LTTRadarView *)initialze;

- (void)setCenterLocation:(CLLocation *)center;
- (void)addBlips:(NSArray *)blips;
- (void)updateBlipViewLocations;
- (void) rotateBlipViews:(NSNumber *) rad;

@property (readonly, nonatomic) NSMutableDictionary *blipIDToView;

@end
