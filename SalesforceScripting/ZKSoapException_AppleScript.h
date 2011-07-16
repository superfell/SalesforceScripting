//
//  ZKSoapException_AppleScript.h
//  SalesforceScripting
//
//  Created by Simon Fell on 6/2/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "zkSoapException.h"

@interface ZKSoapException (AppleScript) 

-(void)setErrorOnCommand:(NSScriptCommand *)cmd;

@end
