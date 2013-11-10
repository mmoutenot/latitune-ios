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
@property (nonatomic) NSString *echonestID;
@property (nonatomic) NSInteger songID;

- (id) initWithTitle:(NSString *)title artist:(NSString*)artist album:(NSString*)album;

- (NSDictionary *)asDictionary;

@end

