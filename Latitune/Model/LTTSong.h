//
//  LTTSong.h
//  Latitune
//
//  Created by alden on 11/9/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTSong : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *providerSongID;
@property (nonatomic) NSString *providerKey;

- (id) initWithTitle:(NSString *)_title artist:(NSString*)_artist album:(NSString*)_album;
- (NSDictionary *)asDictionary;

@end

