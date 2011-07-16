//
//  SaveResult.h
//  SalesforceScripting
//
//  Created by Simon Fell on 6/1/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "AppleScriptItem.h"

@class ZKSaveResult;

@interface SaveResult : AppleScriptItem {
	ZKSaveResult *res;
}

-(id)initWithSaveResult:(ZKSaveResult *)r container:(NSObject *)c collectionName:(NSString *)col;


@property (readonly) NSString *Id;
@property (readonly) NSString *statusCode;
@property (readonly) NSString *message;
@property (readonly) BOOL	success;

@end
