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
      self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)setBlip:(LTTBlip *)blip {
  _blip = blip;
  // Just a hack for now
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
  titleLabel.text = [blip.song.title substringToIndex:3];
  titleLabel.minimumScaleFactor = 0.1;
  titleLabel.adjustsFontSizeToFitWidth = YES;
  [self addSubview:titleLabel];
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
