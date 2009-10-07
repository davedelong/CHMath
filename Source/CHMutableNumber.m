//
//  CHMutableNumber.m
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHMutableNumber.h"
#import "CHNumber_Private.h"

@implementation CHNumber (CHMutableAdditions)

- (CHMutableNumber *) mutableCopy {
	return [[CHMutableNumber alloc] initWithString:[self stringValue]];
}

@end

@implementation CHMutableNumber

- (void) setIntegerValue:(NSInteger)newValue {
	if (newValue < 0) {
		newValue *= -1;
		//set the initial value to the positive value
		BN_set_word([self bigNumber], newValue);
		[self negate];
	} else {
		BN_set_word([self bigNumber], newValue);
	}
}

- (void)setStringValue:(NSString *)newValue {
	NSCharacterSet * decSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
	NSRange nonDecChar = [newValue rangeOfCharacterFromSet:[decSet invertedSet]];
	if (nonDecChar.location != NSNotFound) { return; }
	BN_dec2bn(&bigNumber, [newValue cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)setHexStringValue:(NSString *)newValue {
	NSCharacterSet * hexSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789abcdefABCDEF"];
	NSRange nonHexChar = [newValue rangeOfCharacterFromSet:[hexSet invertedSet]];
	if (nonHexChar.location != NSNotFound) { return; }
	BN_hex2bn(&bigNumber, [newValue cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)clear {
	BN_clear([self bigNumber]);
}

- (void)modByInteger:(NSInteger)mod {
	if (mod != 0) { 
		if (mod < 0) { mod *= -1; }
		NSInteger result = BN_mod_word([self bigNumber], mod);
		[self setIntegerValue:result];
	}
}

- (void)modByNumber:(CHNumber *)mod {
	if ([mod isZero] == NO) {
		BN_mod([self bigNumber], [self bigNumber], [mod bigNumber], context);
	}
}

- (void)addInteger:(NSInteger)addend {
	if (addend > 0) {
		BN_add_word([self bigNumber], addend);
	} else {
		addend *= -1;
		[self subtractInteger:addend];
	}
}

- (void)addNumber:(CHNumber *)addend {
	BN_add([self bigNumber], [self bigNumber], [addend bigNumber]);
}

- (void)addNumber:(CHNumber *)addend mod:(CHNumber *)mod {
	BN_mod_add([self bigNumber], [self bigNumber], [addend bigNumber], [mod bigNumber], context);
}

- (void)subtractInteger:(NSInteger)subtrahend {
	if (subtrahend > 0) {
		BN_sub_word([self bigNumber], subtrahend);
	} else {
		subtrahend *= -1;
		[self addInteger:subtrahend];
	}
}

- (void)subtractNumber:(CHNumber *)subtrahend {
	BN_sub([self bigNumber], [self bigNumber], [subtrahend bigNumber]);
}

- (void)subtractNumber:(CHNumber *)subtrahend mod:(CHNumber *)mod {
	BN_mod_sub([self bigNumber], [self bigNumber], [subtrahend bigNumber], [mod bigNumber], context);
}

- (void)multiplyByInteger:(NSInteger)multiplicand {
	if (multiplicand > 0) {
		BN_mul_word([self bigNumber], multiplicand);
	} else {
		multiplicand *= -1;
		BN_mul_word([self bigNumber], multiplicand);
		[self negate];
	}
}

- (void)multiplyByNumber:(CHNumber *)multiplicand {
	BN_mul([self bigNumber], [self bigNumber], [multiplicand bigNumber], context);
}

- (void)multiplyByNumber:(CHNumber *)multiplicand mod:(CHNumber *)mod {
	BN_mod_mul([self bigNumber], [self bigNumber], [multiplicand bigNumber], [mod bigNumber], context);
}

- (void)divideByInteger:(NSInteger)divisor {
	if (divisor == 0) { return; }
	if (divisor > 0) {
		BN_div_word([self bigNumber], divisor);
	} else {
		divisor *= -1;
		BN_div_word([self bigNumber], divisor);
		[self negate];
	}
}

- (void)divideByNumber:(CHNumber *)divisor {
	if ([divisor isZero]) { return; }
	BN_div([self bigNumber], NULL, [self bigNumber], [divisor bigNumber], context);
}

- (void)raiseToInteger:(NSInteger)exponent {
	CHNumber * exp = [CHNumber numberWithInteger:exponent];
	[self raiseToNumber:exp];
}

- (void)raiseToNumber:(CHNumber *)exponent {
	BN_exp([self bigNumber], [self bigNumber], [exponent bigNumber], context);
}

- (void)raiseToNumber:(CHNumber *)exponent mod:(CHNumber *)mod {
	BN_mod_exp([self bigNumber], [self bigNumber], [exponent bigNumber], [mod bigNumber], context);
}

- (void)square {
	BN_sqr([self bigNumber], [self bigNumber], context);
}

- (void)squareMod:(CHNumber *)mod {
	BN_mod_sqr([self bigNumber], [self bigNumber], [mod bigNumber], context);
}

- (void)negate {
	BN_set_negative([self bigNumber], ![self isNegative]);
}

- (void)setBit:(NSUInteger)bit {
	BN_set_bit([self bigNumber], bit);
}

- (void)clearBit:(NSUInteger)bit {
	BN_clear_bit([self bigNumber], bit);
}

- (void)flipBit:(NSUInteger)bit {
	if ([self isBitSet:bit]) {
		[self clearBit:bit];
	} else {
		[self setBit:bit];
	}
}

- (void)shiftLeftOnce {
	BN_lshift1([self bigNumber], [self bigNumber]);
}

- (void)shiftLeft:(NSUInteger)leftShift {
	BN_lshift([self bigNumber], [self bigNumber], leftShift);
}

- (void)shiftRightOnce {
	BN_rshift1([self bigNumber], [self bigNumber]);
}

- (void)shiftRight:(NSUInteger)rightShift {
	BN_rshift([self bigNumber], [self bigNumber], rightShift);
}

- (void)maskWithInteger:(NSInteger)mask {
	BN_mask_bits([self bigNumber], mask);
}

@end
