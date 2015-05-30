/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBLoginDialog.h"
#import "FBRequest.h"

@protocol FBSessionDelegate;
@class FBFriend;
@class FBAlbum;
@class FBPhoto;
/**
 * Main Facebook interface for interacting with the Facebook developer API.
 * Provides methods to log in and log out a user, make requests using the REST
 * and Graph APIs, and start user interface interactions (such as
 * pop-ups promoting for credentials, permissions, stream posts, etc.)
 */
@interface Facebook : NSObject<FBLoginDialogDelegate>{
    NSString* _accessToken;
    NSDate* _expirationDate;
    id<FBSessionDelegate> _sessionDelegate;
    FBRequest* _request;
    FBDialog* _loginDialog;
    FBDialog* _fbDialog;
    NSString* _appId;
    NSString* _localAppId;
    NSArray* _permissions;
    NSMutableArray* friendsList;
    NSMutableArray* albumList;
    NSMutableArray* photoList;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic, copy) NSDate* expirationDate;
@property(nonatomic, strong) id<FBSessionDelegate> sessionDelegate;
@property(nonatomic, strong) NSMutableArray* friendsList;
@property(nonatomic, strong) NSMutableArray* albumList;
@property(nonatomic, strong) NSMutableArray* photoList;
@property(nonatomic, strong) NSMutableArray* fb_id;
@property(nonatomic, strong) FBAlbum* fbFriendAlbum;
@property(nonatomic, strong) FBPhoto* fbFriendPhoto;
@property(nonatomic, copy) NSString* localAppId;

- (id)initWithAppId:(NSString *)appId
        andDelegate:(id<FBSessionDelegate>)delegate;

- (void)authorize:(NSArray *)permissions;

- (void)authorize:(NSArray *)permissions
       localAppId:(NSString *)localAppId;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)logout:(id<FBSessionDelegate>)delegate;

- (FBRequest*)requestWithParams:(NSMutableDictionary *)params
                    andDelegate:(id <FBRequestDelegate>)delegate;

- (FBRequest*)requestWithMethodName:(NSString *)methodName
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <FBRequestDelegate>)delegate;

- (FBRequest*)requestWithGraphPath:(NSString *)graphPath
                       andDelegate:(id <FBRequestDelegate>)delegate;

- (FBRequest*)requestWithGraphPath:(NSString *)graphPath
                         andParams:(NSMutableDictionary *)params
                       andDelegate:(id <FBRequestDelegate>)delegate;

- (FBRequest*)requestWithGraphPath:(NSString *)graphPath
                         andParams:(NSMutableDictionary *)params
                     andHttpMethod:(NSString *)httpMethod
                       andDelegate:(id <FBRequestDelegate>)delegate;

- (void)dialog:(NSString *)action
   andDelegate:(id<FBDialogDelegate>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <FBDialogDelegate>)delegate;

- (BOOL)isSessionValid;

@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol FBSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout;

@end
