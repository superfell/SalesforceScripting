//
//  UserSession.h
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKSforceClient;
@class UserInfo;

@interface UserSession : AppleScriptItem {
	ZKSforceClient *client;
	NSMutableArray *queryResults, *saveResults, *objDescribes;
	UserInfo		*userInfo;
}

-(id)initWithClient:(ZKSforceClient *)c;


@property (readonly) NSString *serverUrl;
@property (readonly) NSString *sessionId;

@property (readonly) NSArray *queryResults;
@property (readonly) NSArray *saveResults;
@property (readonly) NSArray *userInfos;
@property (readonly) NSArray *objectDescribes; 

-(void)addApiCall:(NSString *)method args:(NSString *)args;

@end
