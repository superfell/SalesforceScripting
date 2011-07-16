//
//  SObjectDescribe.m
//  SalesforceScripting
//
//  Created by Simon Fell on 6/3/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "SObjectDescribe.h"
#import "zkDescribeSObject.h"
#import "zkSforceClient.h"
#import "zkSoapException.h"
#import "ZKSoapException_AppleScript.h"
#import "FieldDescribe.h"
#import "UserSession.h"

@implementation SObjectDescribe

-(id)initWithDescribe:(ZKDescribeGlobalSObject *)d client:(ZKSforceClient *)s container:(UserSession *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	obj = [d retain];
	stub = [s retain];
	session = [c retain];	// retain loop ?
	return self;
}

-(void)dealloc {
	[obj release];
	[detailed release];
	[stub release];
	[fields release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"od";
}

-(NSString *)name {
	return [obj name];
}

-(id)valueForUndefinedKey:(NSString *)k {
	return [obj valueForKey:k];
}

-(ZKDescribeSObject *)detailed {
	@try {
		if (detailed == nil) {
			[session addApiCall:@"describeSobject" args:[obj name]];
			detailed = [[stub describeSObject:[obj name]] retain];
		}
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:[NSScriptCommand currentCommand]];
	}
	return detailed;
}

-(NSString *)urlDetail {
	return [[self detailed] urlDetail];
}

-(NSString *)urlEdit {
	return [[self detailed] urlEdit];
}

-(NSString *)urlNew {
	return [[self detailed] urlNew];
}

-(NSArray *)fields {
	if (fields == nil) {
		NSArray *fds = [[self detailed] fields];
		NSMutableArray *res = [NSMutableArray arrayWithCapacity:[fds count]];
		for (ZKDescribeField *fld in fds) {
			FieldDescribe *f = [[[FieldDescribe alloc] initWithField:fld session:session container:self collectionName:@"fields"] autorelease];
			[res addObject:f];
		}
		fields = [res retain];
	}
	return fields;
}

@end
