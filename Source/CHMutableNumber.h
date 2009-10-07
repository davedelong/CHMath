//
//  CHMutableNumber.h
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHNumber.h"

/**
 @file CHMutableNumber.h
 An arbitrarily long number that can be directly manipulated
 */

@class CHMutableNumber;

@interface CHNumber (CHMutableAdditions)

- (CHMutableNumber *) mutableCopy;

@end

/**
 A mutable subclass of CHNumber.  It allows users to directly manipulate the wrapped BIGNUM.
 */
@interface CHMutableNumber : CHNumber {

}

#pragma mark Behavior

/**
 Changes the value of the receiver
 @param newValue the new integer value of the receiver
 */
- (void)setIntegerValue:(NSInteger)newValue;

/**
 Changes the value of the receiver
 @note if @a newValue contains invalid characters, this method does nothing
 @param newValue the new string value of the receiver
 */
- (void)setStringValue:(NSString *)newValue;

/**
 Changes the value of the receiver
 @note if @a newValue contains invalid characters, this method does nothing
 @param newValue the new hexadecimal string value of the receiver
 */
- (void)setHexStringValue:(NSString *)newValue;

/**
 Clears the value of the receiver and sets it to 0.
 */
- (void)clear;

#pragma mark Mathematical Operations

/**
 Performs a modular divison on the receiver.
 @param mod the NSInteger by which to divide.
 */
- (void)modByInteger:(NSInteger)mod;

/**
 Performs a modular division on the receiver.
 @param mod the CHNumber by which to divide.
 */
- (void)modByNumber:(CHNumber *)mod;

/**
 Adds @a addend to the receiver
 @param addend the NSInteger to add
 */
- (void)addInteger:(NSInteger)addend;

/**
 Adds @a addend to the receiver
 @param addend the CHNumber to add
 */
- (void)addNumber:(CHNumber *)addend;

/**
 Adds @a addend to the receiver and then divides modulo @a mod
 @param addend the CHNumber to add
 @param mod the CHNumber by which to divide
 */
- (void)addNumber:(CHNumber *)addend mod:(CHNumber *)mod;

/**
 Subtracts @a subtrahend from the receiver
 @param subtrahend the NSInteger to subtract
 */
- (void)subtractInteger:(NSInteger)subtrahend;

/**
 Subtracts @a subtrahend from the receiver
 @param subtrahend the CHNumber to subtract
 */
- (void)subtractNumber:(CHNumber *)subtrahend;

/**
 Subtracts @a subtrahend from the receiver and then divides modulo @a mod
 @param subtrahend the CHNumber to subtract
 @param mod the CHNumber by which to divide
 */
- (void)subtractNumber:(CHNumber *)subtrahend mod:(CHNumber *)mod;


/**
 Multiplies the receiver by @a multiplicand
 @param multiplicand the NSInteger by which to multiply
 */
- (void)multiplyByInteger:(NSInteger)multiplicand;

/**
 Multiplies the receiver by @a multiplicand
 @param multiplicand the CHNumber by which to multiply
 */
- (void)multiplyByNumber:(CHNumber *)multiplicand;

/**
 Multiplies the receiver by @a multiplicand and then divides modulo @a mod
 @param multiplicand the CHNumber by which to multiply
 @param mod the CHNumber by which to divide
 */
- (void)multiplyByNumber:(CHNumber *)multiplicand mod:(CHNumber *)mod;

/**
 Divides the receiver by @a divisor
 @param divisor the NSInteger by which to divide
 */
- (void)divideByInteger:(NSInteger)divisor;

/**
 Divides the receiver by @a divisor
 @param divisor the CHNumber by which to divide
 */
- (void)divideByNumber:(CHNumber *)divisor;

/**
 Raises the receiver to the @a exponent power
 @param exponent the NSInteger by which to raise
 */
- (void)raiseToInteger:(NSInteger)exponent;

/**
 Raises the receiver to the @a exponent power
 @param exponent the CHNumber by which to raise
 */
- (void)raiseToNumber:(CHNumber *)exponent;

/**
 Raises the receiver to the @a exponent power and then divides modulo @a mod
 @param exponent the CHNumber by which to raise
 @param mod the CHNumber by which to divide
 */
- (void)raiseToNumber:(CHNumber *)exponent mod:(CHNumber *)mod;

/**
 Squares the receiver
 */
- (void)square;

/**
 Squares the receiver and then divides modulo @a mod
 @param mod the CHNumber by which to divide
 */
- (void)squareMod:(CHNumber *)mod;

#pragma mark Bitfield Operations

/**
 Negates the receiver
 */
- (void)negate;

/**
 Sets the @a bit bit of the receiver to 1
 @note the least significant bit is in position 0
 @param bit the bit to set.
 */
- (void)setBit:(NSUInteger)bit;

/**
 Sets the @a bit bit of the receiver to 0
 @note the least significant bit is in position 0
 @param bit the bit to clear.
 */
- (void)clearBit:(NSUInteger)bit;

/**
 Sets the @a bit bit of the receiver to its NOT.  In other words, if the bit is 1, it will be flipped to 0.  If it is 0, it will be flipped to 1.
 @note the least significant bit is in position 0
 @param bit the bit to flip.
 */
- (void)flipBit:(NSUInteger)bit;

/**
 Perform a single left shift
 */
- (void)shiftLeftOnce;

/**
 Perform a left shift
 @param leftShift the number of bits to shift the receiver left
 */
- (void)shiftLeft:(NSUInteger)leftShift;

/**
 Perform a single right shift
 */
- (void)shiftRightOnce;

/**
 Perform a right shift
 @param rightShift the number of bits to shift the receiver right
 */
- (void)shiftRight:(NSUInteger)rightShift;

/**
 Mask the receiver
 @warning I do not know how this function works
 @return a new CHNumber
 */
- (void)maskWithInteger:(NSInteger)mask;

@end
