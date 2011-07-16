//
//  QueryResult.m
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "QueryResult.h"
#import "zkQueryResult.h"
#import "zkSObject.h"
#import "SObject.h"

@implementation QueryResult

-(id)initWithResults:(ZKQueryResult *)r container:(id)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	results = [r retain];
	NSMutableArray *recs = [NSMutableArray arrayWithCapacity:[[results records] count]];
	for (ZKSObject *row in [r records]) 
		[recs addObject:[SObject sobjectWithZKSobject:row container:self collectionName:@"records"]];
	records = [recs retain];
	return self;
}

-(void)dealloc {
	[records release];
	[results release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"qr";
}

-(NSString *)queryLocator {
	return [results queryLocator];
}

-(NSNumber *)size {
	return [NSNumber numberWithInt:[results size]];
}

-(NSNumber *)done {
	return [NSNumber numberWithBool:[results done]];
}

-(NSArray *)records {
	return records;
}

@end
