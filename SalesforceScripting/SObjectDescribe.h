//
//  SObjectDescribe.h
//  SalesforceScripting
//
//  Created by Simon Fell on 6/3/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKDescribeGlobalSObject;
@class ZKDescribeSObject;
@class ZKSforceClient;
@class UserSession;

@interface SObjectDescribe : AppleScriptItem {
	ZKDescribeGlobalSObject *obj;
	ZKDescribeSObject		*detailed;
	ZKSforceClient			*stub;
	NSArray					*fields;
	UserSession				*session;
}

-(id)initWithDescribe:(ZKDescribeGlobalSObject *)d client:(ZKSforceClient *)stub container:(UserSession *)c collectionName:(NSString *)cn;

-(NSString *)urlDetail;
-(NSString *)urlEdit;
-(NSString *)urlNew;
-(NSArray *)fields;

-(NSString *)name;

@end
