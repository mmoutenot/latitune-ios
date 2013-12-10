//
//  LTTBlipView.m
//  Latitune
//
//  Created by alden on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTBlipView.h"
@interface  LTTBlipView ()

@property (strong, nonatomic) UIButton *heart;
@property (strong, nonatomic) UIImageView *albumArt;

@end

@implementation LTTBlipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _albumArt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blip"]];
      [_albumArt setContentMode:UIViewContentModeCenter];
      [self addSubview:_albumArt];
      
      _heart = [[UIButton alloc] init];
      _heart.frame = CGRectMake(0, 0, 30, 30);
      [_heart setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
      _heart.layer.opacity = .0f;
      [self addSubview:_heart];
      [self sendSubviewToBack:_heart];
    }
    return self;
}

- (void)setBlip:(LTTBlip *)blip {
  _blip = blip;
  _albumArt.image = [UIImage imageNamed:@"blip"];
}

- (IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Blip touched");
  CGRect dispRect = _heart.frame;
  dispRect.origin.x -= 20;
  dispRect.origin.y -= 20;
  [self bringSubviewToFront:_heart];
  [UIView animateWithDuration:0.3f animations:^{
    [_heart setFrame:dispRect];
    _heart.layer.opacity = 1.f;
  }];
}

@end
