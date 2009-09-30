//
//  BNMutableNumber.m
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNMutableNumber.h"
#import "BNNumber_Private.h"

@implementation BNMutableNumber

- (void) setIntegerValue:(NSInteger)newValue {
	if (newValue < 0) {
		newValue *= -1;
		//set the initial value to the positive value
		BN_set_word([self bignum], newValue);
		[self negate];
	} else {
		BN_set_word([self bignum], newValue);
	}
}

- (void)clear {
	BN_clear([self bignum]);
}

- (void)modByInteger:(NSInteger)mod {
	if (mod != 0) { 
		NSInteger result = BN_mod_word([self bignum], mod);
		[self setIntegerValue:result];
	}
}

- (void)modByNumber:(BNNumber *)mod {
	if ([mod isZero] == NO) {
		BN_mod([self bignum], [self bignum], [mod bignum], ctx);
	}
}

- (void)addInteger:(NSInteger)addend {
	BN_add_word([self bignum], addend);
}

- (void)addNumber:(BNNumber *)addend {
	BN_add([self bignum], [self bignum], [addend bignum]);
}

- (void)addNumber:(BNNumber *)addend mod:(BNNumber *)mod {
	BN_mod_add([self bignum], [self bignum], [addend bignum], [mod bignum], ctx);
}

- (void)subtractInteger:(NSInteger)subtrahend {
	BN_sub_word([self bignum], subtrahend);
}

- (void)subtractNumber:(BNNumber *)subtrahend {
	BN_sub([self bignum], [self bignum], [subtrahend bignum]);
}

- (void)subtractNumber:(BNNumber *)subtrahend mod:(BNNumber *)mod {
	BN_mod_sub([self bignum], [self bignum], [subtrahend bignum], [mod bignum], ctx);
}

- (void)multiplyByInteger:(NSInteger)multiplicand {
	BN_mul_word([self bignum], multiplicand);
}

- (void)multiplyByNumber:(BNNumber *)multiplicand {
	BN_mul([self bignum], [self bignum], [multiplicand bignum], ctx);
}

- (void)multiplyByNumber:(BNNumber *)multiplicand mod:(BNNumber *)mod {
	BN_mod_mul([self bignum], [self bignum], [multiplicand bignum], [mod bignum], ctx);
}

- (void)divideByInteger:(NSInteger)divisor {
	if (divisor != 0) { BN_div_word([self bignum], divisor); }
}

- (void)divideByNumber:(BNNumber *)divisor {
	BN_div([self bignum], NULL, [self bignum], [divisor bignum], ctx);
}

- (void)raiseToInteger:(NSInteger)exponent {
	BNNumber * exp = [BNNumber numberWithInteger:exponent];
	[self raiseToNumber:exp];
}

- (void)raiseToNumber:(BNNumber *)exponent {
	BN_exp([self bignum], [self bignum], [exponent bignum], ctx);
}

- (void)raiseToNumber:(BNNumber *)exponent mod:(BNNumber *)mod {
	BN_mod_exp([self bignum], [self bignum], [exponent bignum], [mod bignum], ctx);
}

- (void)square {
	BN_sqr([self bignum], [self bignum], ctx);
}

- (void)squareMod:(BNNumber *)mod {
	BN_mod_sqr([self bignum], [self bignum], [mod bignum], ctx);
}

- (void)negate {
	BN_set_negative([self bignum], ![self isNegative]);
}

- (void)setBit:(NSUInteger)bit {
	BN_set_bit([self bignum], bit);
}

- (void)clearBit:(NSUInteger)bit {
	BN_clear_bit([self bignum], bit);
}

- (void)flipBit:(NSUInteger)bit {
	if ([self isBitSet:bit]) {
		[self clearBit:bit];
	} else {
		[self setBit:bit];
	}
}

- (void)shiftLeftOnce {
	BN_lshift1([self bignum], [self bignum]);
}

- (void)shiftLeft:(NSUInteger)leftShift {
	BN_lshift([self bignum], [self bignum], leftShift);
}

- (void)shiftRightOnce {
	BN_rshift1([self bignum], [self bignum]);
}

- (void)shiftRight:(NSUInteger)rightShift {
	BN_rshift([self bignum], [self bignum], rightShift);
}

- (void)maskWithInteger:(NSInteger)mask {
	BN_mask_bits([self bignum], mask);
}

@end
