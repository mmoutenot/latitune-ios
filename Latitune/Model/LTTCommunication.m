//
//  LLTCommunication.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTTCommunication.h"

#define SERVER_ROOT @"https://latitune.herokuapp.com/api/"

#define BLIP_ROUTE [NSString stringWithFormat:@"%@%@",SERVER_ROOT,@"blip"]
#define SONG_ROUTE [NSString stringWithFormat:@"%@%@",SERVER_ROOT,@"song"]
#define USER_ROUTE [NSString stringWithFormat:@"%@%@",SERVER_ROOT,@"user"]
#define RASA_ROUTE [NSString stringWithFormat:@"%@%@",SERVER_ROOT,@"tabularasa"]

@interface NSNull (DelegateResolver) <CreateUserDelegate, GetBlipsDelegate, AddBlipDelegate, AddSongDelegate, LoginDelegate>
@end

@implementation NSNull (DelegateResolver)

- (void) loginDidFailWithError:(NSNumber *)errorCode {}
- (void) loginDidSucceedWithUser:(NSDictionary *)user {}
- (void) createUserDidFailWithError:(NSNumber *)errorCode {}
- (void) createUserDidSucceedWithUser:(NSDictionary *)user {}
- (void) getBlipsDidFail {}
- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {}
- (void) addBlipDidFail {}
- (void) addBlipDidSucceedWithBlip:(LTTBlip *)song {}
- (void) addSongDidFail {}
- (void) addSongDidSucceedWithSong:(LTTSong *)song {}

@end

@implementation LTTCommunication

@synthesize userID;

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id) init {
  self = [super init];
  if (self) {
    if ([[SSKeychain accountsForService:@"latitune"] count]>0) {
      NSLog(@"loading account");
      NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
      NSLog(@"%@", username);
      NSString *password = [SSKeychain passwordForService:@"latitune" account:username];
      NSLog(@"%@", password);
      [self loginWithUsername:username password:password withDelegate:nil];
    }
    self.http = [AFHTTPRequestOperationManager manager];
  }
  return self;
}

- (id) performSelector: (SEL) selector withObject:(id) p1 withObject: (id) p2 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig)
        return nil;
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo invoke];
    if (sig.methodReturnLength) {
        id anObject;
        [invo getReturnValue:&anObject];
        return anObject;
    }
    return nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)getURL:(NSString*)urlString parameters:(NSDictionary*)params succeedSelector:(SEL)succeedSelector
  failSelector:(SEL) failSelector closure:(NSDictionary*)cl; {
  urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@",urlString,self.username,self.password];
  for (id key in [params allKeys]) {
    urlString = [NSString stringWithFormat:@"%@&%@=%@",urlString,key,params[key]];
  }
  [self.http GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id response){
    NSLog(@"GET. Operation:%@ resp: %@", operation, response);
    NSDictionary *responseDict = (NSDictionary *)response;
    if ([responseDict[@"meta"][@"status"] isEqualToNumber:@(Success)]) {
      [self performSelector:succeedSelector withObject:responseDict withObject:cl];
    } else {
      [self performSelector:failSelector withObject:responseDict[@"meta"][@"status"] withObject:cl];
    }
  } failure:^(AFHTTPRequestOperation *operation, id response){
    [self performSelector:failSelector withObject:cl];
  }];
}

- (void)putURL:(NSString*)urlString parameters:(NSDictionary*)params succeedSelector:(SEL)succeedSelector
        failSelector:(SEL) failSelector closure:(NSDictionary*)cl; {
//    NSString *paramString = [NSString stringWithFormat:@"username=%@&password=%@",self.username,self.password];
//    for (id key in [params allKeys]) {
//        paramString = [NSString stringWithFormat:@"%@&%@=%@",paramString,key,params[key]];
//        [request setPostValue:params[key] forKey:key];
//    }

  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
  [parameters setObject:self.username forKey:@"username"];
  [parameters setObject:self.password forKey:@"password"];

  [self.http PUT:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
    NSLog(@"PUT. Operation:%@ resp: %@", operation, response);
    if ([response[@"meta"][@"status"] isEqualToNumber:@(Success)]) {
      [self performSelector:succeedSelector withObject:response withObject:cl];
    } else {
      [self performSelector:failSelector withObject:response[@"meta"][@"status"] withObject:cl];
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [self performSelector:failSelector withObject:cl];
  }];
}

- (void) requestToAddUserDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
  NSDictionary *user = response[@"objects"][0];
  [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"username"];
  [SSKeychain setPassword:self.password forService:@"latitune" account:self.username];
  self.userID = [user[@"id"] integerValue];
  [cl[@"delegate"] performSelector:@selector(createUserDidSucceedWithUser:) withObject:user];
}

- (void) requestToAddUserDidFailWithErrorCode:(NSNumber *)errorCode closure:(NSDictionary*)cl {
  [cl[@"delegate"] performSelector:@selector(createUserDidFailWithError:) withObject:errorCode];
}

- (void) createUserWithUsername:(NSString *)uname email:(NSString*)uemail password:(NSString*)upassword
                   withDelegate:(NSObject<CreateUserDelegate>*) delegate {
  self.username = uname;
  self.password = upassword;
  NSDictionary *params = @{@"email":uemail};
  NSDictionary *cl = @{@"delegate":delegate};
  [self putURL:USER_ROUTE parameters:params succeedSelector:@selector(requestToAddUserDidSucceedWithResponse:closure:)
  failSelector:@selector(requestToAddUserDidFailWithErrorCode:closure:) closure:cl];
}

- (void) requestToLoginDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
  NSDictionary *user = response[@"objects"][0];
  [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"username"];
  [SSKeychain setPassword:self.password forService:@"latitune" account:self.username];
  self.userID = [user[@"id"] integerValue];
  [cl[@"delegate"] performSelector:@selector(loginDidSucceedWithUser:) withObject:user];
}

- (void) requestToLoginDidFailWithErrorCode:(NSNumber *)errorCode closure:(NSDictionary*)cl {
    [cl[@"delegate"] performSelector:@selector(loginDidFailWithError:) withObject:errorCode];
}

- (void) loginWithUsername:(NSString *)uname password:(NSString *)upassword withDelegate:(NSObject <LoginDelegate>*)delegate {
  if (delegate == nil) delegate = [NSNull null];
    self.username = uname;
    self.password = upassword;
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:USER_ROUTE parameters:nil succeedSelector:@selector(requestToLoginDidSucceedWithResponse:closure:)
    failSelector:@selector(requestToLoginDidFailWithErrorCode:closure:) closure:cl];
}

- (void) addSong:(LTTSong *)song withDelegate:(NSObject<AddSongDelegate> *)delegate {
    NSDictionary *params = [song asDictionary];
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:SONG_ROUTE parameters:params succeedSelector:@selector(requestToAddSongDidSucceedWithResponse:closure:)
          failSelector:@selector(requestToAddSongDidFailWithClosure:) closure:cl];
}

- (void) requestToAddSongDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *song = response[@"objects"][0];
    LTTSong *toReturn = [[LTTSong alloc] initWithTitle:song[@"title"] artist:song[@"artist"] album:song[@"album"] echonestID:song[@"echonestID"]];
    [cl[@"delegate"] performSelector:@selector(addSongDidSucceedWithSong:) withObject:toReturn];
}

- (void) requestToAddSongDidFailWithClosure:(NSDictionary *)cl {
    [cl[@"delegate"] performSelector:@selector(addSongDidFail)];
}

- (void) addBlipWithSong:(LTTSong *)song atLocation:(GeoPoint)point withDelegate:(NSObject <AddBlipDelegate>*)delegate {
    NSDictionary *params = @{@"song_id":song.echonestID,@"latitude":@(point.lat),@"longitude":@(point.lng),@"user_id":@(userID)};
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:BLIP_ROUTE parameters:params succeedSelector:@selector(requestToAddBlipDidSucceedWithResponse:closure:) failSelector:@selector(requestToAddBlipDidFailWithClosure:) closure:cl];
}

- (void) getBlipsWithDelegate:(NSObject<GetBlipsDelegate> *)delegate {
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:BLIP_ROUTE parameters:nil succeedSelector:@selector(requestToGetBlipsDidSucceedWithResponse:closure:) failSelector:@selector(requestToGetBlipsDidFailWithClosure:) closure:cl];
}

- (void) requestToAddBlipDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *blip = response[@"objects"][0];
    LTTBlip *toReturn = [[LTTBlip alloc] init];
    toReturn.userID = [blip[@"user_id"] integerValue];
    NSDictionary *song = blip[@"song"];
    toReturn.song = [[LTTSong alloc] initWithTitle:song[@"title"] artist:song[@"artist"] album:song[@"album"] echonestID:song[@"echonestID"]];
    NSArray *providerDicts = song[@"providers"];
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    for (NSDictionary *providerDict in providerDicts) {
        Provider provider = [providerDict[@"provider"] isEqualToString:@"Rdio"] ? ProviderRdio : ProviderSpotify;
        [providers addObject:[[LTTSongProvider alloc] initWithProvider:provider key:providerDict[@"provider_key"]]];
    }
    toReturn.song.providers = [[NSArray alloc] initWithArray:providers];
    toReturn.song.songID = [song[@"id"] integerValue];
    toReturn.userID = [blip[@"user_id"] integerValue];
    toReturn.timestamp = nil;
    toReturn.lat = [blip[@"latitude"] floatValue];
    toReturn.lng = [blip[@"longitude"] floatValue];
    [cl[@"delegate"] performSelector:@selector(addBlipDidSucceedWithBlip:) withObject:toReturn];
}

- (void) requestToAddBlipDidFailWithClosure:(NSDictionary *)cl {
    [cl[@"delegate"] performSelector:@selector(addBlipDidFail)];
}

- (void) requestToGetBlipsDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
  NSDictionary *blips = response[@"objects"];
  NSMutableArray *toReturn = [[NSMutableArray alloc] init];
  for (NSDictionary *blip in blips) {
    LTTBlip *blipObj = [[LTTBlip alloc] init];
    
    blipObj.blipID = [blip [@"id"] integerValue];
    blipObj.userID = [blip[@"user_id"] integerValue];
    NSDictionary *song = blip[@"song"];
    blipObj.song = [[LTTSong alloc] initWithTitle:song[@"title"] artist:song[@"artist"] album:song[@"album"] echonestID:song[@"echonestID"]];
    NSArray *providerDicts = song[@"providers"];
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    for (NSDictionary *providerDict in providerDicts) {
      Provider provider = [providerDict[@"provider"] isEqualToString:@"Rdio"] ? ProviderRdio : ProviderSpotify;
      [providers addObject:[[LTTSongProvider alloc] initWithProvider:provider key:providerDict[@"provider_key"]]];
    }
    blipObj.song.providers = [[NSArray alloc] initWithArray:providers];
    blipObj.song.songID = [song[@"id"] integerValue];
    blipObj.userID = [blip[@"user_id"] integerValue];
    blipObj.timestamp = nil;
    blipObj.lat = [blip[@"latitude"] floatValue];
    blipObj.lng = [blip[@"longitude"] floatValue];
    [toReturn addObject:blipObj];
  }
  [cl[@"delegate"] performSelector:@selector(getBlipsDidSucceedWithBlips:) withObject:toReturn];
}

- (void) requestToGetBlipsDidFailWithClosure:(NSDictionary*)cl {
  [cl[@"delegate"] performSelector:@selector(getBlipsDidFail)];
}

- (void) getBlipsNearLocation:(GeoPoint)location withDelegate:(NSObject<GetBlipsDelegate>*)delegate {
    NSDictionary *params = @{@"latitude":@(location.lat),@"longitude":@(location.lng)};
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:BLIP_ROUTE parameters:params succeedSelector:@selector(requestToGetBlipsDidSucceedWithResponse:closure:) failSelector:@selector(requestToGetBlipsDidFailWithClosure:) closure:cl];
}

- (void) getBlipWithID:(NSInteger)blipID withDelegate:(NSObject<GetBlipsDelegate> *)delegate {
    NSDictionary *params = @{@"id":@(blipID)};
    NSDictionary *cl = @{@"delegate":delegate};
       [self getURL:BLIP_ROUTE parameters:params succeedSelector:@selector(requestToGetBlipsDidSucceedWithResponse:closure:) failSelector:@selector(requestToGetBlipsDidFailWithClosure:) closure:cl];
}

#pragma clang diagnostic pop

@end
