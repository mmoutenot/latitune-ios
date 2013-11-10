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

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album {
  self = [super init];
  if (self) {
    self.title = title;
    self.artist = artist;
    self.album = album;
    
    NSMutableDictionary *songSearchParameters = [@{ @"title" : title, @"artist" : artist } mutableCopy];
    
    [ENAPIRequest GETWithEndpoint:@"song/search" andParameters:songSearchParameters andCompletionBlock:
     ^(ENAPIRequest *request) {
       self.echonestID = request.response[@"response"][@"songs"][0][@"id"];
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