//
//  LTCommunication.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SBJson.h"
#import "SSKeychain.h"
#import "LTTSong.h"
#import "LTTBlip.h"
#import "LTTSongProvider.h"
#import "Reachability.h"

NSString *NO_INTERNET_ALERT_MESSAGE = @"Latitune can't connect to the tunes! ";
NSString *NO_INTERNET_ALERT_TITLE = @"Can't Connect";

typedef enum {
  Success = 20,
  MissingRequiredParameters = 10,
  EmailDuplicate = 30,
  UsernameDuplicate = 31,
  InvalidAuthentication = 32,
  InvalidUsername = 33,
  InvalidSongID = 40,
  InvalidBlipID = 50,
  InvalidCommentID = 60,
  InvalidFavoriteID = 70,
  FailedToConnect = 600
} LatituneServerStatus;

@protocol AddSongDelegate <NSObject>

- (void) addSongDidFail;
- (void) addSongDidSucceedWithSong:(LTTSong*) song;

@end

@protocol AddBlipDelegate <NSObject>

- (void) addBlipDidFail;
- (void) addBlipDidSucceedWithBlip:(LTTBlip*) song;

@end

@protocol GetBlipsDelegate <NSObject>

- (void) getBlipsDidFail;
- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips;

@end

@protocol CreateUserDelegate <NSObject>

- (void) createUserDidFailWithError:(NSNumber *)errorCode;
- (void) createUserDidSucceedWithUser:(NSDictionary*)user;

@end

@protocol LoginDelegate <NSObject>

- (void) loginDidFailWithError:(NSNumber *)errorCode;
- (void) loginDidSucceedWithUser:(NSDictionary*)user;

@end

@interface LTTCommunication : NSObject

@property (strong,nonatomic) NSString *username, *password;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSDate *lastNoInternetAlert;
@property (nonatomic) AFHTTPRequestOperationManager *http;
@property (nonatomic) Reachability *internetReachability;

+(id)sharedInstance;
- (void) loginWithStoredDataWithDelegate:(NSObject <LoginDelegate>*)delegate;
- (void) loginWithUsername:(NSString *)uname password:(NSString *)password withDelegate:(NSObject <LoginDelegate>*)delegate;
- (void) createUserWithUsername:(NSString *)uname email:(NSString*)uemail password:(NSString*)upassword
                   withDelegate:(NSObject<CreateUserDelegate>*) delegate;
- (void) addSong:(LTTSong *)song withDelegate:(NSObject <AddSongDelegate>*)delegate;
- (void) addBlipWithSong:(LTTSong *)song atLocation:(CLLocationCoordinate2D)loc withDelegate:(NSObject <AddBlipDelegate>*)delegate;
- (void) getBlipsWithDelegate:(NSObject <GetBlipsDelegate> *)delegate;
- (void) getBlipsNearLocation:(CLLocationCoordinate2D)loc withDelegate:(NSObject<GetBlipsDelegate>*)delegate;
- (void) getBlipWithID:(NSInteger)blipID withDelegate:(NSObject<GetBlipsDelegate>*)delegate;
- (void) processAndDelegateNetworkFailureToSelector:(SEL)failSelector withError:(NSError*) error closure:(NSDictionary*)cl;

@end
