//
//  FieldDescribe.m
//  SalesforceScripting
//
//  Created by Simon Fell on 6/4/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "FieldDescribe.h"
#import "UserSession.h"
#import "zkDescribeField.h"
#import "SObjectDescribe.h"

@implementation FieldDescribe

-(id)initWithField:(ZKDescribeField *)f session:(UserSession *)s container:(NSObject *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	field = [f retain];
	session = [s retain]; // retain loop ?
	return self;
}

-(void)dealloc {
	[field release];
	[session release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"fd";
}

-(id)valueForUndefinedKey:(NSString *)k {
	return [field valueForKey:k];
}

-(NSDictionary *)describeDictionary {
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	for (SObjectDescribe *desc in [session objectDescribes])
		[d setObject:desc forKey:[desc name]];
	return d;
}

// we make the applescript version return the SObjectDescribes, rather than just the names.
-(NSArray *)referenceTo {
	NSArray *refToNames = [field referenceTo];
	if ([refToNames count] == 0) return refToNames;
	NSMutableArray *refs = [NSMutableArray arrayWithCapacity:[refToNames count]];
	NSDictionary *descByName = [self describeDictionary];
	
	for (NSString *ref in refToNames) {
		SObjectDescribe *refDesc = [descByName objectForKey:ref];
		[refs addObject:refDesc];
	}
	return refs;
}

@end
