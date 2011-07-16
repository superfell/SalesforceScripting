//
//  SObject.h
//  SalesforceScripting
//
//  Created by Simon Fell on 5/26/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKSObject;

@interface SObject : AppleScriptItem {
	ZKSObject		*row;
	NSMutableArray	*children;
}

+(id)sobjectWithZKSobject:(ZKSObject *)r container:(NSObject *)c collectionName:(NSString *)cn;

@property (readonly) ZKSObject *containedRow;

@property (retain) NSString *type;
@property (retain) NSString *Id;
@property (readonly) NSArray *fields;

-(SObject *)sobjectValue:(NSScriptCommand *)cmd;
-(NSString *)value:(NSScriptCommand *)cmd;
-(NSCalendarDate *)dateValue:(NSScriptCommand *)cmd;
-(NSNumber *)numberValue:(NSScriptCommand *)cmd;

-(void)setValue:(NSScriptCommand *)cmd;

@end
