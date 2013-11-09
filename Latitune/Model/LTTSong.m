//
//  LTTSong.m
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTSong.h"

@implementation LTTSong

// used to get rid of unkown selector warnings
// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album {
  self = [super init];
  if (self) {
    self.title = title;
    self.artist = artist;
    self.album = album;
    self.providerKey = @"";
    self.providerSongID = @"";
  }
  return self;
}

- (NSDictionary *)asDictionary {
  return @{ @"title": self.title,
            @"artist": self.artist,
            @"album": self.album,
            @"provider_key": self.providerKey,
            @"providerSongID": self.providerSongID};
}
@end