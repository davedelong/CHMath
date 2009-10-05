//
//  CHNumberTest.m
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHNumberTest.h"

@implementation CHNumberTest

- (void) setUp {
	return;
}

- (void) tearDown {
	return;
}

- (void) test01_construction {
	CHNumber * n = [CHNumber number];
	STAssertNotNil(n, @"+[CHNumber number] failed");
	STAssertTrue([n integerValue] == 0, @"+[CHNumber number] failed (%@)", n);
	
	n = [CHNumber numberWithHexString:@"abc"];
	STAssertNotNil(n, @"+[CHNumber numberWithHexString:] failed");
	STAssertTrue([n integerValue] == 2748, @"+[CHNumber numberWithHexString:] failed (%@)", n);
	
	n = [CHNumber numberWithHexString:@"xyz"];
	STAssertNil(n, @"+[CHNumber numberWithHexString:] failed validation");
	
	n = [CHNumber numberWithInteger:-42];
	STAssertNotNil(n, @"+[CHNumber numberWithInteger:] failed");
	STAssertTrue([n integerValue] == -42, @"+[CHNumber numberWithInteger:] failed (%@)", n);
	
	n = [CHNumber numberWithNumber:[NSNumber numberWithInteger:42]];
	STAssertNotNil(n, @"+[CHNumber numberWithNumber:] failed");
	STAssertTrue([n integerValue] == 42, @"+[CHNumber numberWithInteger:] failed (%@)", n);
	
	n = [CHNumber numberWithString:@"42"];
	STAssertNotNil(n, @"+[CHNumber numberWithString:] failed");
	STAssertTrue([n integerValue] == 42, @"+[CHNumber numberWithString:] failed (%@)", n);
	
	n = [CHNumber numberWithString:@"-42"];
	STAssertNotNil(n, @"+[CHNumber numberWithString:] failed");
	STAssertTrue([n integerValue] == -42, @"+[CHNumber numberWithString:] failed (%@)", n);
	
	n = [CHNumber numberWithString:@"abc"];
	STAssertNil(n, @"+[CHNumber numberWithString:] failed validation");
	
	n = [CHNumber numberWithUnsignedInteger:42];
	STAssertNotNil(n, @"+[CHNumber numberWithUnsignedInteger:] failed");
	STAssertTrue([n integerValue] == 42, @"+[CHNumber numberWithUnsignedInteger:] failed (%@)", n);
}

- (void) test02_stringValues {
	CHNumber * n = [CHNumber numberWithInteger:42];
	ASSERTTRUE([[n stringValue] isEqual:@"42"], n, @"stringValue");
	ASSERTTRUE([[n hexStringValue] isEqual:@"2A"], n, @"hexStringValue");
	NSString * binary = [n binaryStringValue];
	NSString * exp = @"0101010";
	NSLog(@"%d =? %d", [binary length], [exp length]);
	ASSERTTRUE([binary isEqual:exp], n, @"binaryStringValue");
	
	n = [CHNumber numberWithInteger:-42];
	ASSERTTRUE([[n stringValue] isEqual:@"-42"], n, @"stringValue");
	ASSERTTRUE([[n hexStringValue] isEqual:@"-2A"], n, @"hexStringValue");
	ASSERTTRUE([[n binaryStringValue] isEqual:@"1010110"], n, @"binaryStringValue");
}

- (void) test_factorization {
	CHNumber * n = [CHNumber numberWithInteger:42];
	NSArray * factors = [[n factors] valueForKey:@"stringValue"];
	NSArray * expected = [NSArray arrayWithObjects:@"2", @"3", @"7", nil];
	STAssertTrue([factors isEqual:expected], @"-[CHNumber factors] failed (%@)", factors);
	
	n = [CHNumber numberWithInteger:137];
	factors = [[n factors] valueForKey:@"stringValue"];
	expected = [NSArray array];
	STAssertTrue([factors isEqual:expected], @"-[CHNumber factors] failed (%@)", factors);
}

- (void) test_zero {
	CHNumber * n = [CHNumber number];
	ASSERTTRUE([n isZero], n, @"isZero");
	
	n = [CHNumber numberWithInteger:1];
	ASSERTFALSE([n isZero], n, @"isZero");
}

- (void) test_one {
	CHNumber * n = [CHNumber number];
	ASSERTFALSE([n isOne], n, @"isOne");
	
	n = [CHNumber numberWithInteger:1];
	ASSERTTRUE([n isOne], n, @"isOne");
}

- (void) test_negative {
	CHNumber * n = [CHNumber numberWithInteger:1];
	ASSERTFALSE([n isNegative], n, @"isNegative");
	
	n = [CHNumber numberWithInteger:0];
	ASSERTFALSE([n isNegative], n, @"isNegative");
	
	n = [CHNumber numberWithInteger:-1];
	ASSERTTRUE([n isNegative], n, @"isNegative");
}

- (void) test_positive {
	CHNumber * n = [CHNumber numberWithInteger:1];
	ASSERTTRUE([n isPositive], n, @"isPositive");
	
	n = [CHNumber numberWithInteger:0];
	ASSERTTRUE([n isPositive], n, @"isPositive");
	
	n = [CHNumber numberWithInteger:-1];
	ASSERTFALSE([n isPositive], n, @"isPositive");
}

- (void) test_prime {
	CHNumber * n = [CHNumber numberWithInteger:17];
	ASSERTTRUE([n isPrime], n, @"isPrime");
	
	//561 is a Carmichael number and fails Fermat's little theorem
	n = [CHNumber numberWithInteger:561];
	ASSERTFALSE([n isPrime], n, @"isPrime");
}

- (void) test_odd {
	CHNumber * n = [CHNumber numberWithInteger:39];
	ASSERTTRUE([n isOdd], n, @"isOdd");
	
	n = [CHNumber numberWithInteger:42];
	ASSERTFALSE([n isOdd], n, @"isOdd");
}

- (void) test_even {
	CHNumber * n = [CHNumber numberWithInteger:39];
	ASSERTFALSE([n isEven], n, @"isEven");
	
	n = [CHNumber numberWithInteger:42];
	ASSERTTRUE([n isEven], n, @"isEven");
}

- (void) test_greaterThan {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTTRUE([three isGreaterThanNumber:n1], three, @"isGreaterThanNumber:");
	ASSERTTRUE([three isGreaterThanNumber:one], three, @"isGreaterThanNumber:");
	ASSERTTRUE([n1 isGreaterThanNumber:one], n1, @"isGreaterThanNumber:");
	
	ASSERTFALSE([one isGreaterThanNumber:n1], one, @"isGreaterThanNumber:");
	ASSERTFALSE([n1 isGreaterThanNumber:n2], n1, @"isGreaterThanNumber:");
	ASSERTFALSE([n1 isGreaterThanNumber:three], n1, @"isGreaterThanNumber:");
}

- (void) test_greaterThanOrEqual {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTTRUE([three isGreaterThanOrEqualToNumber:n1], three, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([three isGreaterThanOrEqualToNumber:one], three, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([n1 isGreaterThanOrEqualToNumber:one], n1, @"isGreaterThanOrEqualToNumber:");
	ASSERTTRUE([n1 isGreaterThanOrEqualToNumber:n2], n1, @"isGreaterThanOrEqualToNumber:");
	
	ASSERTFALSE([one isGreaterThanOrEqualToNumber:n1], one, @"isGreaterThanOrEqualToNumber:");
	ASSERTFALSE([n1 isGreaterThanOrEqualToNumber:three], n1, @"isGreaterThanOrEqualToNumber:");
}

- (void) test_lessThan {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTFALSE([three isLessThanNumber:n1], three, @"isLessThanNumber:");
	ASSERTFALSE([three isLessThanNumber:one], three, @"isLessThanNumber:");
	ASSERTFALSE([n1 isLessThanNumber:one], n1, @"isLessThanNumber:");
	ASSERTFALSE([n1 isLessThanNumber:n2], n1, @"isLessThanNumber:");
	
	ASSERTTRUE([one isLessThanNumber:n1], one, @"isLessThanNumber:");
	ASSERTTRUE([n1 isLessThanNumber:three], n1, @"isLessThanNumber:");
}

- (void) test_lessThanOrEqual {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTFALSE([three isLessThanOrEqualToNumber:n1], three, @"isLessThanOrEqualToNumber:");
	ASSERTFALSE([three isLessThanOrEqualToNumber:one], three, @"isLessThanOrEqualToNumber:");
	ASSERTFALSE([n1 isLessThanOrEqualToNumber:one], n1, @"isLessThanOrEqualToNumber:");
	
	ASSERTTRUE([n1 isLessThanOrEqualToNumber:n2], n1, @"isLessThanOrEqualToNumber:");
	ASSERTTRUE([one isLessThanOrEqualToNumber:n1], one, @"isLessThanOrEqualToNumber:");
	ASSERTTRUE([n1 isLessThanOrEqualToNumber:three], n1, @"isLessThanOrEqualToNumber:");
}

- (void) test_equal {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTFALSE([n1 isEqualToNumber:one], n1, @"isEqualToNumber:");
	ASSERTFALSE([n1 isEqualToNumber:three], n1, @"isEqualToNumber:");
	ASSERTFALSE([one isEqualToNumber:n1], one, @"isEqualToNumber:");
	ASSERTFALSE([three isEqualToNumber:n1], three, @"isEqualToNumber:");
	ASSERTFALSE([three isEqualToNumber:one], three, @"isEqualToNumber:");
	
	ASSERTTRUE([n1 isEqualToNumber:n2], n1, @"isEqualToNumber:");
}

- (void) test_compare {
	CHNumber * n1 = [CHNumber numberWithInteger:2];
	CHNumber * n2 = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * one = [CHNumber numberWithInteger:1];
	
	ASSERTTRUE([n1 compare:n2] == NSOrderedSame, n1, @"compareTo:");
	ASSERTTRUE([n1 compare:one] == NSOrderedDescending, n1, @"compareTo:");
	ASSERTTRUE([n1 compare:three] == NSOrderedAscending, n1, @"compareTo:");
}

- (void) test_modularDivision {
	CHNumber * n = [CHNumber numberWithInteger:42];
	CHNumber * m = [CHNumber numberWithInteger:5];
	
	CHNumber * r = [n numberByModding:m];
	ASSERTTRUE([r integerValue] == 2, r, @"numberByModding:");
	
	r = [n numberByInverseModding:m];
	//(42 * result) % 5 == 1
	ASSERTTRUE([r integerValue] == 3, r, @"numberByInverseModding:");
}

- (void) test_addition {
	CHNumber * one = [CHNumber numberWithInteger:1];
	CHNumber * two = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	
	CHNumber * r = [one numberByAdding:two];
	ASSERTTRUE([r integerValue] == 3, r, @"numberByAdding:");
	
	CHNumber * ten = [CHNumber numberWithInteger:10];
	r = [ten numberByAdding:three mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberByAdding:mod:");
}

- (void) test_subtraction {
	CHNumber * two = [CHNumber numberWithInteger:2];
	CHNumber * three = [CHNumber numberWithInteger:3];
	
	CHNumber * r = [three numberBySubtracting:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberBySubtracting:");
	
	CHNumber * ten = [CHNumber numberWithInteger:10];
	r = [ten numberBySubtracting:three mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberBySubtracting:mod:");
}

- (void) test_multiplication {
	CHNumber * three = [CHNumber numberWithInteger:3];
	CHNumber * seven = [CHNumber numberWithInteger:7];
	
	CHNumber * r = [three numberByMultiplyingBy:seven];
	ASSERTTRUE([r integerValue] == 21, r, @"numberByMultiplyingBy:");
	
	CHNumber * two = [CHNumber numberWithInteger:2];
	
	r = [three numberByMultiplyingBy:seven mod:two];
	ASSERTTRUE([r integerValue] == 1, r, @"numberByMultiplyingBy:mod:");	
}

- (void) test_division {
	CHNumber * twentyone = [CHNumber numberWithInteger:21];
	CHNumber * three = [CHNumber numberWithInteger:3];
	
	CHNumber * r = [twentyone numberByDividingBy:three];
	ASSERTTRUE([r integerValue] == 7, r, @"numberByDividingBy:");
	
	//division is integer division, and results are rounded down
	CHNumber * four = [CHNumber numberWithInteger:4];
	r = [twentyone numberByDividingBy:four];
	ASSERTTRUE([r integerValue] == 5, r, @"numberByDividingBy:");
}

- (void) test_squaring {
	CHNumber * two = [CHNumber numberWithInteger:2];
	
	CHNumber * r = [two squaredNumber];
	ASSERTTRUE([r integerValue] == 4, r, @"squaredNumber");
	
	CHNumber * three = [CHNumber numberWithInteger:3];
	
	r = [two squaredNumberMod:three];
	ASSERTTRUE([r integerValue] == 1, r, @"squaredNumberMod:");
}

- (void) test_exponents {
	CHNumber * two = [CHNumber numberWithInteger:2];
	CHNumber * five = [CHNumber numberWithInteger:5];
	
	CHNumber * r = [two numberByRaisingToPower:five];
	ASSERTTRUE([r integerValue] == 32, r, @"numberByRaisingToPower:");
	
	CHNumber * three = [CHNumber numberWithInteger:3];
	r = [two numberByRaisingToPower:five mod:three];
	ASSERTTRUE([r integerValue] == 2, r, @"numberByRaisingToPower:mod:");
}

- (void) test_negation {
	CHNumber * n = [CHNumber numberWithInteger:42];
	
	CHNumber * r = [n negatedNumber];
	ASSERTTRUE([r integerValue] == -42, r, @"negatedNumber");
}

- (void) test_bitSet {
	CHNumber * thirteen = [CHNumber numberWithInteger:13];
	NSUInteger iThirteen = 13;
	for (int i = 0; i < sizeof(NSUInteger)*8; ++i) {
		BOOL isBitSet = (iThirteen >> i) & 1;
		ASSERTTRUE([thirteen isBitSet:i] == isBitSet, [NSNumber numberWithBool:isBitSet], @"isBitSet:");
	}
}

- (void) test_bitShiftLeft {
	CHNumber * three = [CHNumber numberWithInteger:3];
	
	CHNumber * r = [three numberByShiftingLeftOnce];
	ASSERTTRUE([r integerValue] == 6, r, @"numberByShiftingLeftOnce");
	
	r = [three numberByShiftingLeft:3];
	ASSERTTRUE([r integerValue] == 24, r, @"numberByShiftingLeft:");
}

- (void) test_bitShiftRight {
	CHNumber * twentyfour = [CHNumber numberWithInteger:24];
	
	CHNumber * r = [twentyfour numberByShiftingRightOnce];
	ASSERTTRUE([r integerValue] == 12, r, @"numberByShiftingRightOnce");
	
	r = [twentyfour numberByShiftingRight:3];
	ASSERTTRUE([r integerValue] == 3, r, @"numberByShiftingRight:");	
}

- (void) test_bitMasking {
	CHNumber * thirteen = [CHNumber numberWithInteger:13];
	
	CHNumber * r = [thirteen numberByMaskingWithInteger:3];
	ASSERTTRUE([r integerValue] == 5, r, @"numberByMaskingWithInteger:");
}

@end
