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
#import "zkSforceClient.h"
#import "zkUserInfo.h"
#import "QueryResult.h"
#import "SObject.h"
#import "zkSaveResult.h"
#import "SaveResult.h"
#import "UserInfo.h"
#import "ZKSoapException_AppleScript.h"
#import "zkDescribeGlobalSObject.h"
#import "SObjectDescribe.h"
#import "SalesforceScriptingAppDelegate.h"

@implementation UserSession

-(id)initWithClient:(ZKSforceClient *)c {
	self = [super initWithContainer:NSApp collectionName:@"sessions"];
	client = [c retain];
	queryResults = [[NSMutableArray alloc] init];
	saveResults = [[NSMutableArray alloc] init];
	objDescribes = [[NSMutableArray alloc] init];
	userInfo = [[UserInfo alloc] initWithUserInfo:[client currentUserInfo] container:self collectionName:@"userInfos"];
	return self;
}

-(void)dealloc {
	[client release];
	[queryResults release];
	[saveResults release];
	[userInfo release];
	[super dealloc];
}

-(void)addApiCall:(NSString *)method args:(NSString *)args {
	[(SalesforceScriptingAppDelegate *)[NSApp delegate] addApiCall:[self uniqueId] username:[[client currentUserInfo] userName] method:method args:args];
}

-(NSString *)objectPrefix {
	return @"us";
}

-(UserInfo *)userInfo {
	return userInfo;
}

-(NSString *)serverUrl {
	return [client serverUrl];
}

-(NSString *)sessionId {
	return [client sessionId];
}

-(NSArray *)saveResults {
	return saveResults;
}

-(NSArray *)queryResults {
	return queryResults;
}

-(NSArray *)userInfos {
	return [NSArray arrayWithObject:userInfo];
}

-(id)describeGlobal:(NSScriptCommand *)cmd {
	@try {
		[self addApiCall:@"describeGlobal" args:@""];
		NSArray *descs = [client describeGlobal];
		NSMutableArray *res = [NSMutableArray arrayWithCapacity:[descs count]];
		for (ZKDescribeGlobalSObject *d in descs) {
			SObjectDescribe *od = [[[SObjectDescribe alloc] initWithDescribe:d client:client container:self collectionName:@"objectDescribes"] autorelease];
			[res addObject:od];
		}
		[objDescribes addObjectsFromArray:res];
		return res;
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

-(NSArray *)objectDescribes {
	if ([objDescribes count] == 0)
		[self describeGlobal:[NSScriptCommand currentCommand]];
	return objDescribes;
}

-(id)query:(NSScriptCommand *)cmd {
	NSString *soql =[[cmd arguments] objectForKey:@"soql"];
	@try {
		[self addApiCall:@"query" args:soql];
		ZKQueryResult *qr = [client query:soql];
		QueryResult *res = [[[QueryResult alloc] initWithResults:qr container:self collectionName:@"queryResults"] autorelease];
		[queryResults addObject:res];
		return res;
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

-(id)queryMore:(NSScriptCommand *)cmd {
	id locObj = [[cmd evaluatedArguments] objectForKey:@"locator"];
	NSString *ql = [locObj respondsToSelector:@selector(queryLocator)] ? [(QueryResult *)locObj queryLocator] : locObj;
	@try {
		[self addApiCall:@"queryMore" args:ql];
		ZKQueryResult *qr = [client queryMore:ql];
		QueryResult *res = [[[QueryResult alloc] initWithResults:qr container:self collectionName:@"queryResults"] autorelease];
		[queryResults addObject:res];
		return res;
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

-(void)resolve:(NSObject *)item andAddToArray:(NSMutableArray *)arr {
	if ([item isKindOfClass:[SObject class]])
		[arr addObject:[(SObject *)item containedRow]];
	else if ([item respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]) {
		NSObject<NSFastEnumeration> *e = (NSObject<NSFastEnumeration> *)item;
		for (NSObject *i in e)
			[self resolve:i andAddToArray:arr];
	} else if ([item isKindOfClass:[NSScriptObjectSpecifier class]]) {
		[self resolve:[(NSScriptObjectSpecifier *)item objectsByEvaluatingSpecifier] andAddToArray:arr];
	} else {
		NSString *err = [NSString stringWithFormat:@"UserSession.resolve passed unexpected type %@ %@", [item class], item];
		NSLog(@"%@", err);
		[[NSScriptCommand currentCommand] setScriptErrorString:err];
		[[NSScriptCommand currentCommand] setScriptErrorNumber:-1];
	}
}

-(NSArray *)resolveSObjectsFromCommand:(NSScriptCommand *)cmd {
	NSMutableArray *list = [NSMutableArray array];
	NSObject *sobjectsVal = [[cmd evaluatedArguments] objectForKey:@"sobjects"];
	[self resolve:sobjectsVal andAddToArray:list];
	return list;
}

-(NSArray *)makeSaveResults:(NSArray *)zkSaveResults {
	NSMutableArray *srs = [NSMutableArray arrayWithCapacity:[zkSaveResults count]];
	for (ZKSaveResult *r in zkSaveResults) {
		SaveResult *sr = [[[SaveResult alloc] initWithSaveResult:r container:self collectionName:@"saveResults"] autorelease];
		[srs addObject:sr];
	}
	[saveResults addObjectsFromArray:srs];
	return srs;
}

-(id)create:(NSScriptCommand *)cmd {
	NSArray *list = [self resolveSObjectsFromCommand:cmd];
	@try {
		[self addApiCall:@"create" args:[NSString stringWithFormat:@"%d rows of type %@", [list count], [[list objectAtIndex:0] type]]];
		NSArray *results = [client create:list];
		return [self makeSaveResults:results];
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

-(id)update:(NSScriptCommand *)cmd {
	NSArray *list = [self resolveSObjectsFromCommand:cmd];
	@try {
		[self addApiCall:@"update" args:[NSString stringWithFormat:@"%d rows of type %@", [list count], [[list objectAtIndex:0] type]]];
		NSArray *results = [client update:list];
		return [self makeSaveResults:results];
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

-(id)delete:(NSScriptCommand *)cmd {
	NSArray *ids = [[cmd evaluatedArguments] objectForKey:@"Ids"];
	@try {
		[self addApiCall:@"delete" args:[NSString stringWithFormat:@"%d rows", [ids count]]];
		NSArray *results = [client delete:ids];
		return [self makeSaveResults:results]; 
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:cmd];
	}
	return nil;
}

@end
