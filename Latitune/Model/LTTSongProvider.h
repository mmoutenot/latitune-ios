//
//  LTTSongProvider.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Provider : NSInteger Provider;
enum Provider : NSInteger {
    ProviderRdio,
    ProviderSpotify
};

@interface LTTSongProvider : NSObject

@property (nonatomic) NSString *providerKey;
@property (nonatomic) Provider provider;

- (id) initWithProvider:(Provider)provider key:(NSString *)providerKey;

@end
