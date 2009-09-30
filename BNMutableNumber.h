//
//  BNMutableNumber.h
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNNumber.h"

@interface BNMutableNumber : BNNumber {

}

- (void)setIntegerValue:(NSInteger)newValue;
- (void)clear;

- (void)modByInteger:(NSInteger)mod;
- (void)modByNumber:(BNNumber *)mod;

- (void)addInteger:(NSInteger)addend;
- (void)addNumber:(BNNumber *)addend;
- (void)addNumber:(BNNumber *)addend mod:(BNNumber *)mod;

- (void)subtractInteger:(NSInteger)subtrahend;
- (void)subtractNumber:(BNNumber *)subtrahend;
- (void)subtractNumber:(BNNumber *)subtrahend mod:(BNNumber *)mod;

- (void)multiplyByInteger:(NSInteger)multiplicand;
- (void)multiplyByNumber:(BNNumber *)multiplicand;
- (void)multiplyByNumber:(BNNumber *)multiplicand mod:(BNNumber *)mod;

- (void)divideByInteger:(NSInteger)divisor;
- (void)divideByNumber:(BNNumber *)divisor;

- (void)raiseToInteger:(NSInteger)exponent;
- (void)raiseToNumber:(BNNumber *)exponent;
- (void)raiseToNumber:(BNNumber *)exponent mod:(BNNumber *)mod;

- (void)square;
- (void)squareMod:(BNNumber *)mod;

- (void)negate;

- (void)setBit:(NSUInteger)bit;
- (void)clearBit:(NSUInteger)bit;
- (void)flipBit:(NSUInteger)bit;
- (void)shiftLeftOnce;
- (void)shiftLeft:(NSUInteger)leftShift;
- (void)shiftRightOnce;
- (void)shiftRight:(NSUInteger)rightShift;
- (void)maskWithInteger:(NSInteger)mask;

@end
