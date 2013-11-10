//
//  LTTSong.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTSong.h"
#import "ENAPI.h"

@implementation LTTSong

// used to get rid of unkown selector warnings
// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@synthesize providers;

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album {
  self = [super init];
  if (self) {
    self.title = title;
    self.artist = artist;
    self.album = album;
    self.providers = @[];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:title forKey:@"title"];
    [parameters setValue:artist forKey:@"artist"];
    
    [ENAPIRequest GETWithEndpoint:@"song/search" andParameters:parameters andCompletionBlock:
     ^(ENAPIRequest *request) {
       NSLog(@"Echonest response %@", request.response);
     }];
  }
  return self;
}

- (id) initWithTitle:(NSString *)title artist:(NSString *)artist album:(NSString *)album echonestID:(NSString *)echonestID {
  self = [super init];
  if (self) {
    self.title = title;
    self.artist = artist;
    self.album = album;
    self.echonestID = echonestID;
    self.providers = @[];
  }
  return self;
}

- (NSDictionary *)asDictionary {
  return @{ @"title": self.title,
            @"artist": self.artist,
            @"album": self.album,
            @"echonestID":self.echonestID};
}
@end