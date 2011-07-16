//
//  SalesforceScriptingAppDelegate.m
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "SalesforceScriptingAppDelegate.h"

@implementation SalesforceScriptingAppDelegate

@synthesize window;

+ (void)initialize {
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	NSString *prod = [NSString stringWithString:@"https://www.salesforce.com"];
	NSString *test = [NSString stringWithString:@"https://test.salesforce.com"];
	
	NSMutableArray * defaultServers = [NSMutableArray arrayWithObjects:prod, test, nil];
	[defaults setObject:defaultServers forKey:@"servers"];
	[defaults setObject:prod forKey:@"server"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	sessions = [[NSMutableArray alloc] init];
	sobjects = [[NSMutableArray alloc] init];
	apiCalls = [[NSMutableArray alloc] init];
}

-(NSArray *)apiCalls {
	return apiCalls;
}

-(void)insertObject:(NSDictionary *)d inApiCallsAtIndex:(NSUInteger)idx {
	[apiCalls insertObject:d atIndex:idx];
}

-(void)removeObjectFromApiCallsAtIndex:(NSUInteger)idx {
	[apiCalls removeObjectAtIndex:idx];
}

-(void)addApiCall:(NSString *)appleId username:(NSString *)user method:(NSString *)method args:(NSString *)args {
	NSDictionary *call = [NSDictionary dictionaryWithObjectsAndKeys:appleId, @"appleId", user, @"username", method, @"method", args, @"args", [NSDate date], @"timestamp", nil];
	[self insertObject:call inApiCallsAtIndex:[apiCalls count]];
}

-(void)addSession:(UserSession *)s {
	[sessions addObject:s];
}

-(NSArray *)sessions {
	return sessions;
}

- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key { 
    if ([key isEqualToString: @"sessions"]) return YES;
    if ([key isEqualToString: @"sobjects"]) return YES;
    return NO; 
}

-(NSArray *)sobjects {
	return sobjects;
}

- (void)setSobjects:(NSArray *)objs {
	[sobjects autorelease];
	sobjects = [[NSMutableArray arrayWithArray:objs] retain];
}

- (void)insertInSobjects:(SObject *)obj {
	[sobjects addObject:obj];
}

- (void)insertObject:(SObject *)obj inSobjectsAtIndex:(NSUInteger)index {
	[sobjects insertObject:obj atIndex:index];
}

- (void)removeObjectFromSobjectsAtIndex:(NSUInteger)index {
	[sobjects removeObjectAtIndex:index];
}

@end
