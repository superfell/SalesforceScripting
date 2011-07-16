//
//  SaveResult.m
//  SalesforceScripting
//
//  Created by Simon Fell on 6/1/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "SaveResult.h"
#import "zkSaveResult.h"

@implementation SaveResult

-(id)initWithSaveResult:(ZKSaveResult *)r container:(NSObject *)c collectionName:(NSString *)col {
	self = [super initWithContainer:c collectionName:col];
	res = [r retain];
	return self;
}

-(void)dealloc {
	[res release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"sr";
}

-(NSString *)Id {
	return [res id];
}

-(NSString *)statusCode {
	return [res statusCode];
}

-(NSString *)message {
	return [res message];
}

-(BOOL)success {
	return [res success];
}

@end
