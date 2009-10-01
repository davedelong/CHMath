//
//  BNUtilsTest.m
//  BNMath
//
//  Created by Dave DeLong on 9/30/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNUtilsTest.h"

@implementation BNUtilsTest

- (void)test_gcd {
	BNNumber * n = [BNNumber numberWithInteger:39];
	BNNumber * s = [BNNumber numberWithInteger:65];
	
	BNNumber * r = [BNUtils greatestCommonDivisorOf:n and:s];
	STAssertTrue([r integerValue] == 13, @"+[BNUtils greatestCommonDivisorOf:and:] failed (%@)", r);
	
	n = [BNNumber numberWithInteger:17];
	s = [BNNumber numberWithInteger:23];
	r = [BNUtils greatestCommonDivisorOf:n and:s];
	STAssertTrue([r integerValue] == 1, @"+[BNUtils greatestCommonDivisorOf:and:] failed (%@)", r);
}

- (void)test_primesUpTo {
	BNNumber * n = [BNNumber numberWithInteger:43];
	NSArray * p = [[BNUtils primesUpTo:n] valueForKey:@"stringValue"];
	NSArray * expected = [NSArray arrayWithObjects:@"2", @"3", @"5", @"7", @"11", @"13", @"17", @"19", @"23", @"29", @"31", @"37", @"41", nil];
	STAssertTrue([p isEqual:expected], @"+[BNUtils primesUpTo:] failed (%@)", p);
}

@end
