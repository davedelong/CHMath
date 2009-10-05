//
//  CHMutableNumber.h
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHNumber.h"

@interface CHMutableNumber : CHNumber {

}

- (void)setIntegerValue:(NSInteger)newValue;
- (void)clear;

- (void)modByInteger:(NSInteger)mod;
- (void)modByNumber:(CHNumber *)mod;

- (void)addInteger:(NSInteger)addend;
- (void)addNumber:(CHNumber *)addend;
- (void)addNumber:(CHNumber *)addend mod:(CHNumber *)mod;

- (void)subtractInteger:(NSInteger)subtrahend;
- (void)subtractNumber:(CHNumber *)subtrahend;
- (void)subtractNumber:(CHNumber *)subtrahend mod:(CHNumber *)mod;

- (void)multiplyByInteger:(NSInteger)multiplicand;
- (void)multiplyByNumber:(CHNumber *)multiplicand;
- (void)multiplyByNumber:(CHNumber *)multiplicand mod:(CHNumber *)mod;

- (void)divideByInteger:(NSInteger)divisor;
- (void)divideByNumber:(CHNumber *)divisor;

- (void)raiseToInteger:(NSInteger)exponent;
- (void)raiseToNumber:(CHNumber *)exponent;
- (void)raiseToNumber:(CHNumber *)exponent mod:(CHNumber *)mod;

- (void)square;
- (void)squareMod:(CHNumber *)mod;

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
