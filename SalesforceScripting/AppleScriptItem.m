//
//  AppleScriptItem.m
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"


@implementation AppleScriptItem

static int instanceCounter = 0;

-(NSString *)objectPrefix {
	return @"zz";
}

-(id)initWithContainer:(NSObject *)container collectionName:(NSString *)collectionName {
	self = [super init];
	NSString *uniqueId = [NSString stringWithFormat:@"%@_%d", [self objectPrefix], ++instanceCounter];
	objectSpecifier = [[NSUniqueIDSpecifier alloc] initWithContainerClassDescription:[NSScriptClassDescription classDescriptionForClass:[container class]]
										containerSpecifier:[container objectSpecifier]
										key:collectionName
										uniqueID:uniqueId];
	return self;
}

-(void)dealloc {
	[objectSpecifier release];
	[super dealloc];
}

-(NSString *)uniqueId {
	return [objectSpecifier uniqueID];
}

- (NSScriptObjectSpecifier *)objectSpecifier { 
	return objectSpecifier;
}

@end
