//
//  LTTAppDelegate.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import <Crashlytics/Crashlytics.h>

#import "LTTAppDelegate.h"
#import "ENAPI.h"

@implementation LTTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [Crashlytics startWithAPIKey:@"2e702869be33210fc0417066e88ce3f5f2dfd615"];
  
  // Override point for customization after application launch.
  [ENAPIRequest setApiKey:@"DUQVSZTKUIUQIMZXI"];
  _rdio = [[Rdio alloc] initWithConsumerKey:@"xya6sc2u4x73sgvsdtc8ef4k" andSecret:@"hs68psbjtH" delegate:nil];
  [[LTTCommunication sharedInstance] loginWithUsername:@"admin" password:@"admin" withDelegate:self];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (Rdio *) getRdio {
  return _rdio;
}

- (void) loginDidFailWithError:(NSNumber *)errorCode{
  NSLog(@"Login failed: %@", errorCode);
}

- (void) loginDidSucceedWithUser:(NSDictionary *)user {
  NSLog(@"Login succeeded: %@", user);
}

@end
