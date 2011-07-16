//
//  UserInfo.h
//  SalesforceScripting
//
//  Created by Simon Fell on 6/2/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKUserInfo;

@interface UserInfo : AppleScriptItem {
	ZKUserInfo *userInfo;
}

-(id)initWithUserInfo:(ZKUserInfo *)i container:(NSObject *)c collectionName:(NSString *)cn;

@end
