//
//  LTTBlipView.h
//  Latitune
//
//  Created by alden on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTTBlip.h"

@interface LTTBlipView : UIView

@property (nonatomic) LTTBlip *blip;

- (void)setBlip:(LTTBlip *)blip;

@end
