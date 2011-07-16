//
//  SObject.m
//  SalesforceScripting
//
//  Created by Simon Fell on 5/26/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "SObject.h"
#import "zkSObject.h"
#import "SalesforceScriptingAppDelegate.h"

#define FourCC2Str(code) (char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0}

@implementation SObject

-(id)init {
	self = [super initWithContainer:[NSApp delegate] collectionName:@"sobjects"];
	row = [[ZKSObject withType:@""] retain];
	children = [[NSMutableArray alloc] init];
	return self;
}

-(id)initWithZKSobject:(ZKSObject *)r container:(NSObject *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	row = [r retain];
	children = [[NSMutableArray alloc] init];
	return self;
}

-(void)dealloc {
	[row release];
	[children release];
	[super dealloc];
}

+(id)sobjectWithZKSobject:(ZKSObject *)r container:(NSObject *)c collectionName:(NSString *)cn {
	SObject *o = [[[SObject alloc] initWithZKSobject:r container:c collectionName:cn] autorelease];
	return o;
}

-(NSString *)objectPrefix {
	return @"row";
}

-(ZKSObject *)containedRow {
	return row;
}

-(NSString *)Id {
	return [row id];
}

-(void)setId:(NSString *)newId {
	[row setId:newId];
}

-(NSString *)type {
	return [row type];
}

-(void)setType:(NSString *)type {
	[row setType:type];
}

-(NSArray *)fields {
	return [row orderedFieldNames];
}

-(NSArray *)children {
	return children;
}

typedef struct _ObjectAndPath {
	ZKSObject *row;
	NSArray	  *path;
} ObjectAndPath;

-(ObjectAndPath)resolvePath:(NSScriptCommand *)cmd {
	NSString *path = [[cmd arguments] objectForKey:@"fieldName"];
	NSArray *steps = [path componentsSeparatedByString:@"."];
	ZKSObject *r = row;
	int pos = 0;
	while ([steps count] > 1 + pos) {
		r = [r fieldValue:[steps objectAtIndex:pos]];
		// check type of r
		pos++;
	}
	ObjectAndPath res = { r, steps };
	return res;
}

-(SObject *)sobjectValue:(NSScriptCommand *)cmd {
	ObjectAndPath p = [self resolvePath:cmd];
	SObject *c = [SObject sobjectWithZKSobject:[p.row fieldValue:[p.path lastObject]] container:self collectionName:@"children"];
	[children addObject:c];
	return c;
}

-(NSString *)value:(NSScriptCommand *)cmd {
	ObjectAndPath p = [self resolvePath:cmd];
	return [p.row fieldValue:[p.path lastObject]];
}

-(NSDate *)dateValue:(NSScriptCommand *)cmd {
	ObjectAndPath p = [self resolvePath:cmd];
	return [p.row dateTimeValue:[p.path lastObject]];
}

-(NSNumber *)numberValue:(NSScriptCommand *)cmd {
	ObjectAndPath p = [self resolvePath:cmd];
	return [NSNumber numberWithDouble:[p.row doubleValue:[p.path lastObject]]];
}

-(void)setValue:(NSScriptCommand *)cmd {	
	NSLog(@"command %@", cmd);
	NSLog(@"arguments %@", [cmd arguments]);
	NSLog(@"eval args %@", [cmd evaluatedArguments]);
	NSLog(@"apple event %@", [cmd appleEvent]);
	
	NSString *fn = [[cmd arguments] objectForKey:@"fieldName"];
	NSObject *v = [[cmd arguments] objectForKey:@"value"];
	NSNumber *dateOnly = [[cmd arguments] objectForKey:@"dateOnly"];
	
	NSLog(@"setValue called for field %@, value %@, %@", fn, [v class], v);
	if ([v isKindOfClass:[NSString class]])
		[row setFieldValue:v field:fn];
	else if ([v isKindOfClass:[NSDate class]])
		if ([dateOnly boolValue])	
			[row setFieldDateValue:(NSDate *)v field:fn];
		else
			[row setFieldDateTimeValue:(NSDate *)v field:fn];
	else if ([v isKindOfClass:[NSNumber class]])
		[row setFieldValue:v field:fn];
	else
		NSLog(@"unhandled type in setValue: %@, %@", [v class], v);
		
	NSLog(@"row now %@", row);
}

-(void)setToNull:(NSScriptCommand *)cmd {
	[row setFieldToNull:[[cmd arguments] objectForKey:@"fieldName"]];

	NSLog(@"row now %@", row);
}

@end
