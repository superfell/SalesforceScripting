//
//  ZKSObjectTest
//  SalesforceScripting
//
//  Created by Simon Fell on 6/2/10.
//  Copyright 2010 Simon Fell. All rights reserved.
//

#import "ZKSObjectTest.h"
#import "zkSObject.h"

@implementation ZKSObjectTestCase

NSDate * makeDateTime(int y, int m, int d, int h, int min, int s) {
	NSDateComponents *dc = [[[NSDateComponents alloc] init] autorelease];
	[dc setYear:y];
	[dc setMonth:m];
	[dc setDay:d];
	[dc setHour:h];
	[dc setMinute:min];
	[dc setSecond:s];
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	return [gregorian dateFromComponents:dc];	
}

NSDate * makeDate(int y, int m, int d) {
	return makeDateTime(y,m,d,0,0,0);
}

+(void)initialize {
	[NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
}

-(void)setUp {
	o = [ZKSObject withType:@"Account"];
}

-(void)testDateFormating {
	NSDate *d = makeDate(2010,5,22);
	[o setFieldDateValue:d field:@"test"];
	STAssertEqualObjects(@"2010-05-22", [o fieldValue:@"test"], @"Date not serialized correctly");
	
	NSDate *d2 = [o dateValue:@"test"];
	STAssertEqualObjects(d, d2, @"Date from SObject not correct");
	
	d = makeDate(2010,1,1);
	[o setFieldDateValue:d field:@"test"];
	STAssertEqualObjects(@"2010-01-01", [o fieldValue:@"test"], @"date padding in serialization is wrong");
}

-(void)testDateTimeFormatting {
	[o setFieldValue:@"2010-05-22T23:39:59.0000Z" field:@"test"];
	
	NSDate *d = [o dateTimeValue:@"test"];
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *dc = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:d];
	STAssertEquals(2010, [dc year], @"year is wrong, got %d", [dc year]);
	STAssertEquals(5, [dc month], @"month is wrong, got %d", [dc month]);
	STAssertEquals(22, [dc day], @"day is wrong, got %d", [dc day]);
	STAssertEquals(23, [dc hour], @"hour is wrong, got %d", [dc hour]);
	STAssertEquals(39, [dc minute], @"minute is wrong, got %d", [dc minute]);
	STAssertEquals(59, [dc second], @"seconds is wrong, got %d", [dc second]);
}

-(void)testDateTimeSerializer {
	NSDate *d = makeDateTime(2010,11,21, 23,9,12);
	[o setFieldDateTimeValue:d field:@"test"];
	STAssertEqualObjects(@"2010-11-21T23:09:12.0000+00:00", [o fieldValue:@"test"], @"serialized dateTime is wrong");
}	

@end
