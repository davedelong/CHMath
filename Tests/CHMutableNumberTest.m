/*
 CHMath.framework -- CHMutableNumberTest.m
 
 Copyright (c) 2008-2009, Dave DeLong <http://www.davedelong.com>
 
 Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
 
 The software is  provided "as is", without warranty of any kind, including all implied warranties of merchantability and fitness. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
 */


#import "CHMutableNumberTest.h"

@implementation CHMutableNumberTest

- (void) setUp {
	return;
}

- (void) tearDown {
	return;
}

- (void) test_setAndClear {
	CHMutableNumber * n = [CHMutableNumber number];
	[n setIntegerValue:42];
	ASSERTTRUE([n integerValue] == 42, n, @"setIntegerValue:");
	
	[n setStringValue:@"138"];
	ASSERTTRUE([n integerValue] == 138, n, @"setStringValue:");
	
	[n setHexStringValue:@"2A"];
	ASSERTTRUE([n integerValue] == 42, n, @"setHexStringValue:");
	
	[n clear];
	ASSERTTRUE([n integerValue] == 0, n, @"clear");
}

- (void) test_modularDivision {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:42];
	[n modByInteger:4];
	ASSERTTRUE([n integerValue] == 2, n, @"modByInteger:");
	
	n = [CHMutableNumber numberWithInteger:42];
	CHNumber * mod = [CHNumber numberWithInteger:9];
	[n modByNumber:mod];
	ASSERTTRUE([n integerValue] == 6, n, @"modByNumber:");
}

- (void) test_addition {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:42];
	[n addInteger:17];
	ASSERTTRUE([n integerValue] == 59, n, @"addInteger:");
	
	[n addNumber:[CHNumber numberWithInteger:17]];
	ASSERTTRUE([n integerValue] == 76, n, @"addNumber:");
	
	[n addNumber:[CHNumber numberWithInteger:1] mod:[CHNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 2, n, @"addNumber:mod:");
	
}

- (void) test_subtraction {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:42];
	[n subtractInteger:17];
	ASSERTTRUE([n integerValue] == 25, n, @"subtractInteger:");
	
	[n subtractNumber:[CHNumber numberWithInteger:17]];
	ASSERTTRUE([n integerValue] == 8, n, @"subtractNumber:");
	
	[n subtractNumber:[CHNumber numberWithInteger:1] mod:[CHNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 1, n, @"subtractNumber:mod:");
}

- (void) test_multiplication {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:7];
	[n multiplyByInteger:3];
	ASSERTTRUE([n integerValue] == 21, n, @"multiplyByInteger:");
	
	[n multiplyByNumber:[CHNumber numberWithInteger:2]];
	ASSERTTRUE([n integerValue] == 42, n, @"multiplyByNumber:");
	
	[n multiplyByNumber:[CHNumber numberWithInteger:2] mod:[CHNumber numberWithInteger:5]];
	ASSERTTRUE([n integerValue] == 4, n, @"multiplyByNumber:mod:");
}

- (void) test_division {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:21];
	[n divideByInteger:3];
	ASSERTTRUE([n integerValue] == 7, n, @"divideByInteger:");
	
	//division is integer division, and results are rounded down
	n = [CHMutableNumber numberWithInteger:21];
	[n divideByInteger:4];
	ASSERTTRUE([n integerValue] == 5, n, @"divideByInteger:");
	
	n = [CHMutableNumber numberWithInteger:21];
	[n divideByNumber:[CHNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 7, n, @"divideByInteger:");
	
	//division is integer division, and results are rounded down
	n = [CHMutableNumber numberWithInteger:21];
	[n divideByNumber:[CHNumber numberWithInteger:4]];
	ASSERTTRUE([n integerValue] == 5, n, @"divideByInteger:");
}

- (void) test_squaring {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:2];
	[n square];
	ASSERTTRUE([n integerValue] == 4, n, @"square");
	
	n = [CHMutableNumber numberWithInteger:3];
	CHNumber * mod = [CHNumber numberWithInteger:4];
	[n squareMod:mod];
	ASSERTTRUE([n integerValue] == 1, n, @"squareMod:");
}

- (void) test_exponents {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:2];
	[n raiseToInteger:5];
	ASSERTTRUE([n integerValue] == 32, n, @"raiseToInteger:");
	
	n = [CHMutableNumber numberWithInteger:2];
	[n raiseToNumber:[CHNumber numberWithInteger:5]];
	ASSERTTRUE([n integerValue] == 32, n, @"raiseToNumber:");
	
	n = [CHMutableNumber numberWithInteger:2];
	[n raiseToNumber:[CHNumber numberWithInteger:5] mod:[CHNumber numberWithInteger:3]];
	ASSERTTRUE([n integerValue] == 2, n, @"raiseToNumber:mod:");
}

- (void) test_negation {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:-42];
	[n negate];
	ASSERTTRUE([n integerValue] == 42, n, @"negate");
	
	[n negate];
	ASSERTTRUE([n integerValue] == -42, n, @"negate");
	
}

- (void) test_bitSetting {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:15];
	[n setBit:0];
	ASSERTTRUE([n integerValue] == 15, n, @"setBit:");
	
	[n clearBit:0];
	ASSERTTRUE([n integerValue] == 14, n, @"clearBit:");
	
	[n flipBit:1];
	ASSERTTRUE([n integerValue] == 12, n, @"flipBit:");
}

- (void) test_bitShiftLeft {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:3];
	[n shiftLeftOnce];
	ASSERTTRUE([n integerValue] == 6, n, @"shiftLeftOnce");
	
	n = [CHMutableNumber numberWithInteger:3];
	[n shiftLeft:3];
	ASSERTTRUE([n integerValue] == 24, n, @"shiftLeft:");
}

- (void) test_bitShiftRight {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:24];
	[n shiftRightOnce];
	ASSERTTRUE([n integerValue] == 12, n, @"shiftRightOnce");
	
	n = [CHMutableNumber numberWithInteger:24];
	[n shiftRight:3];
	ASSERTTRUE([n integerValue] == 3, n, @"shiftRight:");	
}

- (void) test_bitMasking {
	CHMutableNumber * n = [CHMutableNumber numberWithInteger:13];
	[n maskWithInteger:3];
	ASSERTTRUE([n integerValue] == 5, n, @"maskWithInteger:");
}

@end
