//
//  BNMutableNumberTest.m
//  BNMath
//
//  Created by Dave DeLong on 9/30/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNMutableNumberTest.h"

@implementation BNMutableNumberTest

- (void) setUp {
	return;
}

- (void) tearDown {
	return;
}

- (void) test_setAndClear {
	BNMutableNumber * n = [BNMutableNumber number];
	[n setIntegerValue:42];
	ASSERTTRUE([n integerValue] == 42, n, @"setIntegerValue:");
	
	[n clear];
	ASSERTTRUE([n integerValue] == 0, n, @"clear");
}

- (void) test_modularDivision {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:42];
	[n modByInteger:4];
	ASSERTTRUE([n integerValue] == 2, n, @"modByInteger:");
	
	n = [BNMutableNumber numberWithInteger:42];
	BNNumber * mod = [BNNumber numberWithInteger:9];
	[n modByNumber:mod];
	ASSERTTRUE([n integerValue] == 6, n, @"modByNumber:");
}

- (void) test_addition {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:42];
	[n addInteger:17];
	ASSERTTRUE([n integerValue] == 59, n, @"addInteger:");
	
	[n addNumber:[BNNumber numberWithInteger:17]];
	ASSERTTRUE([n integerValue] == 76, n, @"addNumber:");
	
	[n addNumber:[BNNumber numberWithInteger:1] mod:[BNNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 2, n, @"addNumber:mod:");
	
}

- (void) test_subtraction {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:42];
	[n subtractInteger:17];
	ASSERTTRUE([n integerValue] == 25, n, @"subtractInteger:");
	
	[n subtractNumber:[BNNumber numberWithInteger:17]];
	ASSERTTRUE([n integerValue] == 8, n, @"subtractNumber:");
	
	[n subtractNumber:[BNNumber numberWithInteger:1] mod:[BNNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 1, n, @"subtractNumber:mod:");
}

- (void) test_multiplication {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:7];
	[n multiplyByInteger:3];
	ASSERTTRUE([n integerValue] == 21, n, @"multiplyByInteger:");
	
	[n multiplyByNumber:[BNNumber numberWithInteger:2]];
	ASSERTTRUE([n integerValue] == 42, n, @"multiplyByNumber:");
	
	[n multiplyByNumber:[BNNumber numberWithInteger:2] mod:[BNNumber numberWithInteger:5]];
	ASSERTTRUE([n integerValue] == 4, n, @"multiplyByNumber:mod:");
}

- (void) test_division {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:21];
	[n divideByInteger:3];
	ASSERTTRUE([n integerValue] == 7, n, @"divideByInteger:");
	
	//division is integer division, and results are rounded down
	n = [BNMutableNumber numberWithInteger:21];
	[n divideByInteger:4];
	ASSERTTRUE([n integerValue] == 5, n, @"divideByInteger:");
	
	n = [BNMutableNumber numberWithInteger:21];
	[n divideByNumber:[BNNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 7, n, @"divideByInteger:");
	
	//division is integer division, and results are rounded down
	n = [BNMutableNumber numberWithInteger:21];
	[n divideByNumber:[BNNumber numberWithInteger:4]];
	ASSERTTRUE([n integerValue] == 5, n, @"divideByInteger:");
}

- (void) test_squaring {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:2];
	[n square];
	ASSERTTRUE([n integerValue] == 4, n, @"square");
	
	n = [BNMutableNumber numberWithInteger:3];
	BNNumber * mod = [BNNumber numberWithInteger:4];
	[n squareMod:mod];
	ASSERTTRUE([n integerValue] == 1, n, @"squareMod:");
}

- (void) test_exponents {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:2];
	[n raiseToInteger:5];
	ASSERTTRUE([n integerValue] == 32, n, @"raiseToInteger:");
	
	n = [BNMutableNumber numberWithInteger:2];
	[n raiseToNumber:[BNNumber numberWithInteger:5]];
	ASSERTTRUE([n integerValue] == 32, n, @"raiseToNumber:");
	
	n = [BNMutableNumber numberWithInteger:2];
	[n raiseToNumber:[BNNumber numberWithInteger:5] mod:[BNNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 2, n, @"raiseToNumber:mod:");
}

- (void) test_negation {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:-42];
	[n negate];
	ASSERTTRUE([n integerValue] == 42, n, @"negate");
	
	[n negate];
	ASSERTTRUE([n integerValue] == -42, n, @"negate");
	
}

- (void) test_bitSetting {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:15];
	[n setBit:0];
	ASSERTTRUE([n integerValue] == 15, n, @"setBit:");
	
	[n clearBit:0];
	ASSERTTRUE([n integerValue] == 14, n, @"clearBit:");
	
	[n flipBit:1];
	ASSERTTRUE([n integerValue] == 12, n, @"flipBit:");
}

- (void) test_bitShiftLeft {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:3];
	[n shiftLeftOnce];
	ASSERTTRUE([n integerValue] == 6, n, @"shiftLeftOnce");
	
	n = [BNMutableNumber numberWithInteger:3];
	[n shiftLeft:3];
	ASSERTTRUE([n integerValue] == 24, n, @"shiftLeft:");
}

- (void) test_bitShiftRight {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:24];
	[n shiftRightOnce];
	ASSERTTRUE([n integerValue] == 12, n, @"shiftRightOnce");
	
	n = [BNMutableNumber numberWithInteger:24];
	[n shiftRight:3];
	ASSERTTRUE([n integerValue] == 3, n, @"shiftRight:");	
}

- (void) test_bitMasking {
	BNMutableNumber * n = [BNMutableNumber numberWithInteger:13];
	[n maskWithInteger:3];
	ASSERTTRUE([n integerValue] == 5, n, @"maskWithInteger:");
}

@end
