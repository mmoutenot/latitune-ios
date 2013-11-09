//
//  LTTPlayerViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface LTTPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *authenticateButton;
@property (strong, nonatomic) IBOutlet UIView *authenticateOverlay;

- (IBAction)authenticateWithRdio:(id)sender;

@end
