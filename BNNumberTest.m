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
	STAssertNil(n, @"+[BNNumber numberWithHexString:] failed validation");
	
	n = [BNNumber numberWithInteger:-42];
	STAssertNotNil(n, @"+[BNNumber numberWithInteger:] failed");
	
	n = [BNNumber numberWithNumber:[NSNumber numberWithInteger:42]];
	STAssertNotNil(n, @"+[BNNumber numberWithNumber:] failed");
	
	n = [BNNumber numberWithString:@"42"];
	STAssertNotNil(n, @"+[BNNumber numberWithString:] failed");
	
	n = [BNNumber numberWithString:@"١٣٨"];
	STAssertNotNil(n, @"+[BNNumber numberWithString:] failed (Arabic)");
	
	n = [BNNumber numberWithString:@"abc"];
	STAssertNil(n, @"+[BNNumber numberWithString:] failed validation");
	
	n = [BNNumber numberWithUnsignedInteger:42];
	STAssertNotNil(n, @"+[BNNumber numberWithUnsignedInteger:] failed");
}

- (void) test02_stringValues {
	BNNumber * n = [BNNumber numberWithInteger:42];
	ASSERTTRUE([[n stringValue] isEqual:@"42"], n, @"stringValue");
	ASSERTTRUE([[n hexStringValue] isEqual:@"2A"], n, @"hexStringValue");
	ASSERTTRUE([[n binaryStringValue] isEqual:@"101010"], n, @"binaryStringValue");
	
	n = [BNNumber numberWithInteger:-42];
	ASSERTTRUE([[n stringValue] isEqual:@"-42"], n, @"stringValue");
	ASSERTTRUE([[n hexStringValue] isEqual:@"-2A"], n, @"hexStringValue");
	ASSERTTRUE([[n binaryStringValue] isEqual:@"11010110"], n, @"binaryStringValue");
}

- (void) test_factorization {
	BNNumber * n = [BNNumber numberWithInteger:42];
	NSArray * factors = [[n factors] valueForKey:@"stringValue"];
	NSArray * expected = [NSArray arrayWithObjects:@"2", @"3", @"7", nil];
	STAssertTrue([factors isEqual:expected], @"-[BNNumber factors] failed (%@)", factors);
	
	n = [BNNumber numberWithInteger:137];
	factors = [[n factors] valueForKey:@"stringValue"];
	expected = [NSArray array];
	STAssertTrue([factors isEqual:expected], @"-[BNNumber factors] failed (%@)", factors);
}

- (void) test_zero {
	BNNumber * n = [BNNumber number];
	ASSERTTRUE([n isZero], n, @"isZero");
	
	n = [BNNumber numberWithInteger:1];
	ASSERTFALSE([n isZero], n, @"isZero");
}

- (void) test_one {
	BNNumber * n = [BNNumber number];
	ASSERTFALSE([n isOne], n, @"isOne");
	
	n = [BNNumber numberWithInteger:1];
	ASSERTTRUE([n isOne], n, @"isOne");
}

- (void) test_negative {
	BNNumber * n = [BNNumber numberWithInteger:1];
	ASSERTFALSE([n isNegative], n, @"isNegative");
	
	n = [BNNumber numberWithInteger:0];
	ASSERTFALSE([n isNegative], n, @"isNegative");
	
	n = [BNNumber numberWithInteger:-1];
	ASSERTTRUE([n isNegative], n, @"isNegative");
}

- (void) test_positive {
	BNNumber * n = [BNNumber numberWithInteger:1];
	ASSERTTRUE([n isPositive], n, @"isPositive");
	
	n = [BNNumber numberWithInteger:0];
	ASSERTTRUE([n isPositive], n, @"isPositive");
	
	n = [BNNumber numberWithInteger:-1];
	ASSERTFALSE([n isPositive], n, @"isPositive");
}

- (void) test_prime {
	BNNumber * n = [BNNumber numberWithInteger:17];
	ASSERTTRUE([n isPrime], n, @"isPrime");
	
	//561 is a Carmichael number and fails Fermat's little theorem
	n = [BNNumber numberWithInteger:561];
	ASSERTFALSE([n isPrime], n, @"isPrime");
}

- (void) test_odd {
	BNNumber * n = [BNNumber numberWithInteger:39];
	ASSERTTRUE([n isOdd], n, @"isOdd");
	
	n = [BNNumber numberWithInteger:42];
	ASSERTFALSE([n isOdd], n, @"isOdd");
}

- (void) test_even {
	BNNumber * n = [BNNumber numberWithInteger:39];
	ASSERTFALSE([n isEven], n, @"isEven");
	
	n = [BNNumber numberWithInteger:42];
	ASSERTTRUE([n isEven], n, @"isEven");
}

- (void) test_greaterThan {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTTRUE([three isGreaterThanNumber:n1], three, @"isGreaterThanNumber:");
	ASSERTTRUE([three isGreaterThanNumber:one], three, @"isGreaterThanNumber:");
	ASSERTTRUE([n1 isGreaterThanNumber:one], n1, @"isGreaterThanNumber:");
	
	ASSERTFALSE([one isGreaterThanNumber:n1], one, @"isGreaterThanNumber:");
	ASSERTFALSE([n1 isGreaterThanNumber:n2], n1, @"isGreaterThanNumber:");
	ASSERTFALSE([n1 isGreaterThanNumber:three], n1, @"isGreaterThanNumber:");
}

- (void) test_greaterThanOrEqual {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTTRUE([three isGreaterThanOrEqualToNumber:n1], three, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([three isGreaterThanOrEqualToNumber:one], three, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([n1 isGreaterThanOrEqualToNumber:one], n1, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([n1 isGreaterThanOrEqualToNumber:n2], n1, @"isGreaterThanOrEqualToNumber:");
	
	ASSERTFALSE([one isGreaterThanOrEqualToNumber:n1], one, @"isGreaterThanOrEqualToNumber:");
	ASSERTFALSE([n1 isGreaterThanOrEqualToNumber:three], n1, @"isGreaterThanOrEqualToNumber:");
}

- (void) test_lessThan {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTFALSE([three isLessThanNumber:n1], three, @"isLessThanNumber:");
	ASSERTFALSE([three isLessThanNumber:one], three, @"isLessThanNumber:");
	ASSERTFALSE([n1 isLessThanNumber:one], n1, @"isLessThanNumber:");
	ASSERTFALSE([n1 isLessThanNumber:n2], n1, @"isLessThanNumber:");
	
	ASSERTTRUE([one isLessThanNumber:n1], one, @"isLessThanNumber:");
	ASSERTTRUE([n1 isLessThanNumber:three], n1, @"isLessThanNumber:");
}

- (void) test_lessThanOrEqual {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTFALSE([three isLessThanOrEqualToNumber:n1], three, @"isLessThanOrEqualToNumber:");
	ASSERTFALSE([three isLessThanOrEqualToNumber:one], three, @"isLessThanOrEqualToNumber:");
	ASSERTFALSE([n1 isLessThanOrEqualToNumber:one], n1, @"isLessThanOrEqualToNumber:");
	
	ASSERTTRUE([n1 isLessThanOrEqualToNumber:n2], n1, @"isLessThanOrEqualToNumber:");
	ASSERTTRUE([one isLessThanOrEqualToNumber:n1], one, @"isLessThanOrEqualToNumber:");
	ASSERTTRUE([n1 isLessThanOrEqualToNumber:three], n1, @"isLessThanOrEqualToNumber:");
}

- (void) test_equal {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTFALSE([n1 isEqualToNumber:one], n1, @"isEqualToNumber:");
	ASSERTFALSE([n1 isEqualToNumber:three], n1, @"isEqualToNumber:");
	ASSERTFALSE([one isEqualToNumber:n1], one, @"isEqualToNumber:");
	ASSERTFALSE([three isEqualToNumber:n1], three, @"isEqualToNumber:");
	ASSERTFALSE([three isEqualToNumber:one], three, @"isEqualToNumber:");
	
	ASSERTTRUE([n1 isEqualToNumber:n2], n1, @"isEqualToNumber:");
}

- (void) test_compare {
	BNNumber * n1 = [BNNumber numberWithInteger:2];
	BNNumber * n2 = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * one = [BNNumber numberWithInteger:1];
	
	ASSERTTRUE([n1 compareTo:n2] == NSOrderedSame, n1, @"compareTo:");
	ASSERTTRUE([n1 compareTo:one] == NSOrderedDescending, n1, @"compareTo:");
	ASSERTTRUE([n1 compareTo:three] == NSOrderedAscending, n1, @"compareTo:");
}

- (void) test_modularDivision {
	BNNumber * n = [BNNumber numberWithInteger:42];
	BNNumber * m = [BNNumber numberWithInteger:5];
	
	BNNumber * r = [n numberByModding:m];
	ASSERTTRUE([r integerValue] == 2, r, @"numberByModding:");
	
	r = [n numberByInverseModding:m];
	//(42 * result) % 5 == 1
	ASSERTTRUE([r integerValue] == 3, r, @"numberByInverseModding:");
}

- (void) test_addition {
	BNNumber * one = [BNNumber numberWithInteger:1];
	BNNumber * two = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	
	BNNumber * r = [one numberByAdding:two];
	ASSERTTRUE([r integerValue] == 3, r, @"numberByAdding:");
	
	BNNumber * ten = [BNNumber numberWithInteger:10];
	r = [ten numberByAdding:three mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberByAdding:mod:");
}

- (void) test_subtraction {
	BNNumber * two = [BNNumber numberWithInteger:2];
	BNNumber * three = [BNNumber numberWithInteger:3];
	
	BNNumber * r = [three numberBySubtracting:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberBySubtracting:");
	
	BNNumber * ten = [BNNumber numberWithInteger:10];
	r = [ten numberBySubtracting:three mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberBySubtracting:mod:");
}

- (void) test_multiplication {
	BNNumber * three = [BNNumber numberWithInteger:3];
	BNNumber * seven = [BNNumber numberWithInteger:7];
	
	BNNumber * r = [three numberByMultiplyingBy:seven];
	ASSERTTRUE([r integerValue] == 21, r, @"numberByMultiplyingBy:");
	
	BNNumber * two = [BNNumber numberWithInteger:2];
	
	r = [three numberByMultiplyingBy:seven mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberByMultiplyingBy:mod:");	
}

- (void) test_division {
	BNNumber * twentyone = [BNNumber numberWithInteger:21];
	BNNumber * three = [BNNumber numberWithInteger:3];
	
	BNNumber * r = [twentyone numberByDividingBy:three];
	ASSERTTRUE([r integerValue] == 7, r, @"numberByDividingBy:");
	
	//division is integer division, and results are rounded down
	BNNumber * four = [BNNumber numberWithInteger:4];
	r = [twentyone numberByDividingBy:four];
	ASSERTTRUE([r integerValue] == 5, r, @"numberByDividingBy:");
}

- (void) test_squaring {
	BNNumber * two = [BNNumber numberWithInteger:2];
	
	BNNumber * r = [two squaredNumber];
	ASSERTTRUE([r integerValue] == 4, r, @"squaredNumber");
	
	BNNumber * three = [BNNumber numberWithInteger:3];
	
	r = [two squaredNumberMod:three];
	ASSERTTRUE([r integerValue] == 1, r, @"squaredNumberMod:");
}

- (void) test_exponents {
	BNNumber * two = [BNNumber numberWithInteger:2];
	BNNumber * five = [BNNumber numberWithInteger:5];
	
	BNNumber * r = [two numberByRaisingToPower:five];
	ASSERTTRUE([r integerValue] == 32, r, @"numberByRaisingToPower:");
	
	BNNumber * three = [BNNumber numberWithInteger:3];
	r = [two numberByRaisingToPower:five mod:three];
	ASSERTTRUE([r integerValue] == 2, r, @"numberByRaisingToPower:mod:");
}

- (void) test_negation {
	BNNumber * n = [BNNumber numberWithInteger:42];
	
	BNNumber * r = [n negatedNumber];
	ASSERTTRUE([r integerValue] == -42, r, @"negatedNumber");
}

- (void) test_bitSet {
	BNNumber * thirteen = [BNNumber numberWithInteger:13];
	NSUInteger iThirteen = 13;
	for (int i = 0; i < sizeof(NSUInteger)*8; ++i) {
		BOOL isBitSet = (iThirteen >> i) & 1;
		ASSERTTRUE([thirteen isBitSet:i] == isBitSet, [NSNumber numberWithBool:isBitSet], @"isBitSet:");
	}
}

- (void) test_bitShiftLeft {
	BNNumber * three = [BNNumber numberWithInteger:3];
	
	BNNumber * r = [three numberByShiftingLeftOnce];
	ASSERTTRUE([r integerValue] == 6, r, @"numberByShiftingLeftOnce");
	
	r = [three numberByShiftingLeft:3];
	ASSERTTRUE([r integerValue] == 24, r, @"numberByShiftingLeft:");
}

- (void) test_bitShiftRight {
	BNNumber * twentyfour = [BNNumber numberWithInteger:24];
	
	BNNumber * r = [twentyfour numberByShiftingRightOnce];
	ASSERTTRUE([r integerValue] == 12, r, @"numberByShiftingRightOnce");
	
	r = [twentyfour numberByShiftingRight:3];
	ASSERTTRUE([r integerValue] == 3, r, @"numberByShiftingRight:");	
}

- (void) test_bitMasking {
	BNNumber * thirteen = [BNNumber numberWithInteger:13];
	
	BNNumber * r = [thirteen numberByMaskingWithInteger:3];
	ASSERTTRUE([r integerValue] == 5, r, @"numberByMaskingWithInteger:");
}

@end
