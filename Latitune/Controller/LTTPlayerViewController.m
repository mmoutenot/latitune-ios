//
//  LTTPlayerViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTPlayerViewController.h"
#import "LTTAppDelegate.h"

@interface LTTPlayerViewController ()

@end

@implementation LTTPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authenticateWithRdio:(id)sender
{
    Rdio *rdio = [(LTTAppDelegate *)[[UIApplication sharedApplication] delegate] rdio];
    [rdio authorizeFromController:self];
}

@end
