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


#import "FieldDescribe.h"
#import "UserSession.h"
#import "zkDescribeField.h"
#import "SObjectDescribe.h"

@implementation FieldDescribe

-(id)initWithField:(ZKDescribeField *)f session:(UserSession *)s container:(NSObject *)c collectionName:(NSString *)cn {
	self = [super initWithContainer:c collectionName:cn];
	field = [f retain];
	session = [s retain]; // retain loop ?
	return self;
}

-(void)dealloc {
	[field release];
	[session release];
	[super dealloc];
}

-(NSString *)objectPrefix {
	return @"fd";
}

-(id)valueForUndefinedKey:(NSString *)k {
	return [field valueForKey:k];
}

-(NSDictionary *)describeDictionary {
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	for (SObjectDescribe *desc in [session objectDescribes])
		[d setObject:desc forKey:[desc name]];
	return d;
}

// we make the applescript version return the SObjectDescribes, rather than just the names.
-(NSArray *)referenceTo {
	NSArray *refToNames = [field referenceTo];
	if ([refToNames count] == 0) return refToNames;
	NSMutableArray *refs = [NSMutableArray arrayWithCapacity:[refToNames count]];
	NSDictionary *descByName = [self describeDictionary];
	
	for (NSString *ref in refToNames) {
		SObjectDescribe *refDesc = [descByName objectForKey:ref];
		[refs addObject:refDesc];
	}
	return refs;
}

@end
