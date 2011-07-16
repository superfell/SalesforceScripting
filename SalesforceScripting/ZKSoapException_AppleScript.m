//
//  ZKSoapException_AppleScript.m
//  SalesforceScripting
//
//  Created by Simon Fell on 6/2/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "ZKSoapException_AppleScript.h"


@implementation ZKSoapException(AppleScript)

-(void)setErrorOnCommand:(NSScriptCommand *)cmd {
	[cmd setScriptErrorNumber:-([[self faultCode] hash] & 0xFFFF)];	// give different faultCodes different error numbers without us having to declare them all.
	[cmd setScriptErrorString:[self reason]];
}

@end
