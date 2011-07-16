//
//  FieldDescribe.h
//  SalesforceScripting
//
//  Created by Simon Fell on 6/4/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKDescribeField;
@class UserSession;

@interface FieldDescribe : AppleScriptItem {
	ZKDescribeField *field;
	UserSession		*session;
}

-(id)initWithField:(ZKDescribeField *)f session:(UserSession *)s container:(NSObject *)c collectionName:(NSString *)cn;

@end
