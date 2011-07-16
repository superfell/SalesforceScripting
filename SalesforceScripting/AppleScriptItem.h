//
//  AppleScriptItem.h
//  SalesforceScripting
//
//  Created by Simon Fell on 5/24/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppleScriptItem : NSObject {
	NSUniqueIDSpecifier *objectSpecifier;
}

-(id)initWithContainer:(id)container collectionName:(NSString *)collectionName;

@property (readonly) NSString *uniqueId;

@end
