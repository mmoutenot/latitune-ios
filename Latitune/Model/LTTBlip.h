//
//  LTTBlip.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LTTSong.h"

@interface LTTBlip : NSObject

@property (nonatomic) NSInteger blipID, userID;
@property (nonatomic) LTTSong *song;
@property (nonatomic) CLLocationDegrees lat;
@property (nonatomic) CLLocationDegrees lng;
@property (nonatomic) NSDate *timestamp;

@end
