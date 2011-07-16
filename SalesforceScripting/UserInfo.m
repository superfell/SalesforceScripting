//
//  UserInfo.m
//  SalesforceScripting
//
//  Created by Simon Fell on 6/2/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "UserInfo.h"
#import "zkUserInfo.h"

@implementation UserInfo

-(id)initWithUserInfo:(ZKUserInfo *)i container:(NSObject *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	userInfo = [i retain];
	return self;
}

-(void)dealloc {
	[userInfo release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"user";
}

-(id)valueForKey:(NSString *)k {
	if ([k isEqualToString:@"uniqueId"]) return [self uniqueId];
	return [userInfo valueForKey:k];
}

@end
