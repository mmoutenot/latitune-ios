//
//  LTTPlayerViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTPlayerViewController.h"

@interface LTTPlayerViewController ()

@end

@implementation LTTPlayerViewController

@synthesize rdio;

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
    rdio = [[Rdio alloc] initWithConsumerKey:@"xya6sc2u4x73sgvsdtc8ef4k" andSecret:@"hs68psbjtH" delegate:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
