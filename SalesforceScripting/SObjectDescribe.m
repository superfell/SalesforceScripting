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


#import "SObjectDescribe.h"
#import "zkDescribeSObject.h"
#import "zkSforceClient.h"
#import "zkSoapException.h"
#import "ZKSoapException_AppleScript.h"
#import "FieldDescribe.h"
#import "UserSession.h"

@implementation SObjectDescribe

-(id)initWithDescribe:(ZKDescribeGlobalSObject *)d client:(ZKSforceClient *)s container:(UserSession *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	obj = [d retain];
	stub = [s retain];
	session = [c retain];	// retain loop ?
	return self;
}

-(void)dealloc {
	[obj release];
	[detailed release];
	[stub release];
	[fields release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"od";
}

-(NSString *)name {
	return [obj name];
}

-(id)valueForUndefinedKey:(NSString *)k {
	return [obj valueForKey:k];
}

-(ZKDescribeSObject *)detailed {
	@try {
		if (detailed == nil) {
			[session addApiCall:@"describeSobject" args:[obj name]];
			detailed = [[stub describeSObject:[obj name]] retain];
		}
	} @catch (ZKSoapException *ex) {
		[ex setErrorOnCommand:[NSScriptCommand currentCommand]];
	}
	return detailed;
}

-(NSString *)urlDetail {
	return [[self detailed] urlDetail];
}

-(NSString *)urlEdit {
	return [[self detailed] urlEdit];
}

-(NSString *)urlNew {
	return [[self detailed] urlNew];
}

-(NSArray *)fields {
	if (fields == nil) {
		NSArray *fds = [[self detailed] fields];
		NSMutableArray *res = [NSMutableArray arrayWithCapacity:[fds count]];
		for (ZKDescribeField *fld in fds) {
			FieldDescribe *f = [[[FieldDescribe alloc] initWithField:fld session:session container:self collectionName:@"fields"] autorelease];
			[res addObject:f];
		}
		fields = [res retain];
	}
	return fields;
}

@end
