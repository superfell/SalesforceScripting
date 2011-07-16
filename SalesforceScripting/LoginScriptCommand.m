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