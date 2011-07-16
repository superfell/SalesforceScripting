//
//  SalesforceScriptingAppDelegate.h
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UserSession;
@class SObject;

@interface SalesforceScriptingAppDelegate : NSObject  {
    NSWindow *window;
	
	NSMutableArray *sessions, *sobjects;
	NSMutableArray *apiCalls;
}

@property (assign) IBOutlet NSWindow *window;

@property (readonly) NSArray *sessions;
-(void)addSession:(UserSession *)s;

-(NSArray *)sobjects;
- (void)setSobjects:(NSArray *)objs;
- (void)insertInSobjects:(SObject *)obj;
- (void)insertObject:(SObject *)att inSobjectsAtIndex:(NSUInteger)index;
- (void)removeObjectFromSobjectsAtIndex:(NSUInteger)index;


-(void)addApiCall:(NSString *)appleId username:(NSString *)user method:(NSString *)method args:(NSString *)args;

// for KVO
-(NSArray *)apiCalls;
-(void)insertObject:(NSDictionary *)d inApiCallsAtIndex:(NSUInteger)idx;
-(void)removeObjectFromApiCallsAtIndex:(NSUInteger)idx;
@end
