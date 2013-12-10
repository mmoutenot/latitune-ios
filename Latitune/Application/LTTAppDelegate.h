//
//  LTTAppDelegate.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Rdio/Rdio.h>

#import "LTTCommunication.h"

@interface LTTAppDelegate : UIResponder <UIApplicationDelegate, LoginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Rdio *rdio;

@end
