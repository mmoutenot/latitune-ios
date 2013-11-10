//
//  LTTSongProvider.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/13.
//  Copyright (c) 2013 Alden Keefe Sampson. All rights reserved.
//

#import "LTTSongProvider.h"

@implementation LTTSongProvider

@synthesize provider, providerKey;

- (id) initWithProvider:(Provider)_provider key:(NSString *)_providerKey
{
    self = [super init];
    if (self)
    {
        self.provider = _provider;
        self.providerKey = _providerKey;
    }
    return self;
}

@end
