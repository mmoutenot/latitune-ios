//
//  LTTPlayerViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTTSong.h"

@interface LTTPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

- (IBAction)playPause:(id)sender;

- (void) playSong:(LTTSong *) song;
@end
