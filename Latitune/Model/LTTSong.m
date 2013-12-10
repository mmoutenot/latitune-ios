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

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album {
  self = [super init];
  if (self) {
    _title = title;
    _artist = artist;
    _album = album;
  }
  return self;
}

- (id) initWithTitle:(NSString *)title artist:(NSString *)artist album:(NSString *)album echonestID:(NSString *)echonestID {
  self = [super init];
  if (self) {
    _title = title;
    _artist = artist;
    _album = album;
    _echonestID = echonestID;
    _providers = @[];
  }
  return self;
}

- (void) populateEchonestIDWithDelegate:(NSObject <LTTSongDelegate>*)delegate {
  _echonestID = @"1";
  [delegate populateEchonestIDSucceededForSong:self];
//  NSMutableDictionary *songSearchParameters = [@{ @"title" : _title, @"artist" : _artist } mutableCopy];
//  [ENAPIRequest GETWithEndpoint:@"song/search" andParameters:songSearchParameters andCompletionBlock:
//   ^(ENAPIRequest *request) {
//     _echonestID = request.response[@"response"][@"songs"][0][@"id"];
//     [delegate populateEchonestIDSucceededForSong:self];
//   }];
}

- (NSDictionary *)asDictionary {
  return @{ @"title": _title,
            @"artist": _artist,
            @"album": _album,
	    @"echonest_id": _echonestID};
}
@end
