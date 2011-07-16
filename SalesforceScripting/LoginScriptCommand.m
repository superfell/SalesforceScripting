//
//  LoginScriptCommand.m
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "UserSession.h"
#import "LoginScriptCommand.h"
#import "zkSforceClient.h"
#import "SalesforceScriptingAppDelegate.h"
#import "zkSoapException.h"
#import "ZKSoapException_AppleScript.h"
#import "ZKLoginController.h"

@implementation LoginScriptCommand

- (id)performDefaultImplementation {
	ZKSforceClient *stub = [[[ZKSforceClient alloc] init] autorelease];
	NSDictionary *args = [self arguments];
	NSString *un = [args objectForKey:@"username"];
	NSString *pwd = [args objectForKey:@"password"];
	
	@try {
		[[NSApp delegate] addApiCall:@"" username:un method:@"login" args:@""];
		[stub login:un password:pwd];
		UserSession *session = [[(UserSession *)[UserSession alloc] initWithClient:stub] autorelease];
		[[NSApp delegate] addSession:session];
		return session;
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:self];
	}
	return nil;
}

@end

@implementation LoginWindowScriptCommand 

-(BOOL)autoLogin {
	return NO;
}

- (id)performDefaultImplementation {
	ZKLoginController *lc = [[[ZKLoginController alloc] init] autorelease];
	ZKSforceClient *stub = [lc showModalLoginWindow:self submitIfHaveCredentials:[self autoLogin]];
	if (stub == nil) return nil;
	
	UserSession *session = [[(UserSession *)[UserSession alloc] initWithClient:stub] autorelease];
	[[NSApp delegate] addSession:session];
	return session;
}

@end

@implementation LoginAutoScriptCommand

-(BOOL)autoLogin {
	return YES;
}

@end