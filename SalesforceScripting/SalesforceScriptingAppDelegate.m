// Copyright (c) 2010 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
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
