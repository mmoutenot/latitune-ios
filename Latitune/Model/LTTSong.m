//
//  LTTSong.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//
#import "ENAPI.h"

#import "LTTSong.h"

@interface NSNull (DelegateResolver) <LTTSongDelegate>
@end

@implementation LTTSong

// used to get rid of unkown selector warnings
// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

@synthesize providers;

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album {
  self = [super init];
  if (self) {
    self.title = title;
    self.artist = artist;
    self.album = album;
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

- (void) populateEchonestIDWithDelegate:(NSObject <LTTSongDelegate>*)delegate {
  NSMutableDictionary *songSearchParameters = [@{ @"title" : self.title, @"artist" : self.artist } mutableCopy];

  [ENAPIRequest GETWithEndpoint:@"song/search" andParameters:songSearchParameters andCompletionBlock:
   ^(ENAPIRequest *request) {
     self.echonestID = request.response[@"response"][@"songs"][0][@"id"];
     [delegate populateEchonestIDSuccessWithSong:self];
   }];

}

- (NSDictionary *)asDictionary {
  return @{ @"title": self.title,
            @"artist": self.artist,
            @"album": self.album,
	    @"echonest_id":self.echonestID};
}
@end
