//
//  QueryResult.h
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppleScriptItem.h"

@class ZKQueryResult;

@interface QueryResult : AppleScriptItem {
	ZKQueryResult	*results;
	NSArray			*records;
}

-(id)initWithResults:(ZKQueryResult *)r container:(id)c collectionName:(NSString *)cn;

-(NSString *)queryLocator;
-(NSNumber *)size;
-(NSNumber *)done;
-(NSArray *)records;

@end
