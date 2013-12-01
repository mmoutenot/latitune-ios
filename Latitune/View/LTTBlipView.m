//
//  LTTBlipView.m
//  Latitune
//
//  Created by alden on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTBlipView.h"

@implementation LTTBlipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setBlip:(LTTBlip *)blip {
  _blip = blip;
  UIImageView *albumArt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blip"]];
  [self addSubview:albumArt];
}

- (void)rotate:(NSNumber *) rad {
  [UIView animateWithDuration:0.2
                   animations:^{
                     CGAffineTransform  xform = CGAffineTransformMakeRotation(rad.floatValue);
                     self.transform = xform;
                     [self setNeedsDisplay];
                   } completion:^(BOOL finished){
                   }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
