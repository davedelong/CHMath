//
//  BNNumberTest.m
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNNumberTest.h"


@implementation BNNumberTest

- (void) setUp {
	return;
}

- (void) tearDown {
	return;
}

- (void) test01_construction {
	BNNumber * n = [BNNumber number];
	STAssertNotNil(n, @"+[BNNumber number] failed");
	
	n = [BNNumber numberWithHexString:@"abc"];
	STAssertNotNil(n, @"+[BNNumber numberWithHexString:] failed");
	
	n = [BNNumber numberWithHexString:@"xyz"];
	STAssertNil(n, @"+[BNNumber numberWithHexString:] failed");
	
	n = [BNNumber numberWithInteger:-42];
	STAssertNotNil(n, @"+[BNNumber numberWithInteger:] failed");
	
	n = [BNNumber numberWithNumber:[NSNumber numberWithInteger:42]];
	STAssertNotNil(n, @"+[BNNumber numberWithNumber:] failed");
	
	n = [BNNumber numberWithString:@"42"];
	STAssertNotNil(n, @"+[BNNumber numberWithString:] failed");
	
	n = [BNNumber numberWithString:@"١٣٨"];
	STAssertNotNil(n, @"+[BNNumber numberWithString:] failed (Arabic)");
	
	n = [BNNumber numberWithString:@"abc"];
	STAssertNil(n, @"+[BNNumber numberWithString:] failed");
	
	n = [BNNumber numberWithUnsignedInteger:42];
	STAssertNotNil(n, @"+[BNNumber numberWithUnsignedInteger:] failed");
}

@end
