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

@interface LTTRadarViewController : UIViewController <CLLocationManagerDelegate> {
  CLLocationManager *locationManager;
}

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *compassImage;

@end
