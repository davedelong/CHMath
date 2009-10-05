//
//  CHNumber.h
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/bn.h>

/**
 @file CHNumber.h
 A arbitrarily long integer
 */

/**
 CHNumber is a wrapper that represents an arbitrarily long integer.  It provides methods for adding, subtracting, dividing, and multiplying with other CHNumbers.
 
 CHNumber wraps the BIGNUM type of the OpenSSL library.
 */
@interface CHNumber : NSObject <NSCoding, NSCopying> {
	BIGNUM *bigNumber;
	BN_CTX *context;
}

#pragma mark Initializers

/**
 Creates an autoreleased CHNumber initialized to 0.
 @return a new CHNumber, or @a nil if an error occurs
 */
+ (id)number;

/**
 Creates an autoreleased CHNumber initialized to @a integer.
 @param integer the integer value of the new number
 @return a new CHNumber, or @a nil if an error occurs
 */
+ (id)numberWithInteger:(NSInteger)integer;

/**
 Creates an autoreleased CHNumber initialized to @a integer.
 @param integer the unsigned integer value of the new number
 @return a new CHNumber, or @a nil if an error occurs
 */
+ (id)numberWithUnsignedInteger:(NSUInteger)integer;

/**
 Creates an autoreleased CHNumber initialized to the value represented by @a string.
 @param string an NSString of decimal characters (0 - 9)
 @return a new CHNumber, or @a nil if a number cannot be extracted from @a string
 */
+ (id)numberWithString:(NSString *)string;

/**
 Creates an autoreleased CHNumber initialized to the value represented by @a string
 @param string an NSString of hexadecimal characters (0 - 9, A - F)
 @return a new CHNumber, or @a nil if a number cannot be extracted from @a string
 */
+ (id)numberWithHexString:(NSString *)string;

/**
 Creates an autoreleased CHNumber initialized to the value of @a number
 @param number an NSNumber that represents an integer value
 @return a new CHNumber, or @a nil if an integer cannot be extracted from @a number.
 */
+ (id)numberWithNumber:(NSNumber *)number;

- (id)initWithInteger:(NSInteger)integer;
- (id)initWithUnsignedInteger:(NSUInteger)integer;
- (id)initWithString:(NSString *)string;
- (id)initWithHexString:(NSString *)string;
- (id)initWithNumber:(NSNumber *)number;

#pragma mark Behavior

/**
 Creates a two's complement binary representation of the integer as an NSString
 @return an NSString
 */
- (NSString *)binaryStringValue;

/**
 Creates a hexadecimal representation of the integer as an NSString
 @return an NSString
 */
- (NSString *)hexStringValue;

/**
 Creates a decimal representation of the integer as an NSString
 @return an NSString
 */
- (NSString *)stringValue;

/**
 Returns the receiver's value as an NSInteger
 @note if the receiver's integer value is too large to be expressed in a single NSInteger, this method returns 0xFFFFFFFFFFFFFFFF.
 @return an NSInteger
 */
- (NSInteger)integerValue;

/**
 Returns the receiver's value as an NSUInteger
 @note if the receiver's integer value is too large to be expressed in a single NSUInteger, this method returns 0xFFFFFFFFFFFFFFFF.
 @return an NSUInteger
 */
- (NSUInteger)unsignedIntegerValue;

/**
 Returns the receiver's prime factors
 @note depending on the size of the receiver, this method may take a very long time to return
 @return an NSArray of CHNumbers.
 */
- (NSArray *)factors;

#pragma mark Comparisons

/**
 Returns a boolean indicating whether the receiver is equal to 0.
 @return @c YES if the receiver is equal to 0, @c NO otherwise.
 */
- (BOOL)isZero;

/**
 Returns a boolean indicating whether the receiver is equal to 1.
 @return @c YES if the receiver is equal to 1, @c NO otherwise.
 */
- (BOOL)isOne;

/**
 Returns a boolean indicating whether the receiver is less than 0.
 @return @c YES if the receiver is less than 0, @c NO otherwise.
 */
- (BOOL)isNegative;

/**
 Returns a boolean indicating whether the receiver is greater than or equal to 0.
 @return @c YES if the receiver is greater than or equal to 0, @c NO otherwise.
 */
- (BOOL)isPositive;

/**
 Returns a boolean indicating whether the receiver is a prime number.
 @return @c YES if the receiver is a prime number.
 */
- (BOOL)isPrime;

/**
 Returns a boolean indicating whether the receiver is an odd number.
 @return @c YES if the receiver is odd, @c NO otherwise.
 */
- (BOOL)isOdd;

/**
 Returns a boolean indicating whether the receiver is an even number.
 @return @c YES if the receiver is even, @c NO otherwise.
 */
- (BOOL)isEven;

/**
 Returns a boolean indicating whether the receiver is greather than @a number.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param number another CHNumber
 @return @c YES if the receiver is greater than @a number, @c NO otherwise.
 */
- (BOOL)isGreaterThanNumber:(CHNumber *)number;

/**
 Returns a boolean indicating whether the receiver is greather than or equal to @a number.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param number another CHNumber
 @return @c YES if the receiver is greater than or equal to @a number, @c NO otherwise.
 */
- (BOOL)isGreaterThanOrEqualToNumber:(CHNumber *)number;

/**
 Returns a boolean indicating whether the receiver is equal to @a number.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param number another CHNumber
 @return @c YES if the receiver is equal to @a number, @c NO otherwise.
 */
- (BOOL)isEqualToNumber:(CHNumber *)number;

/**
 Returns a boolean indicating whether the receiver is less than @a number.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param number another CHNumber
 @return @c YES if the receiver is less than @a number, @c NO otherwise.
 */
- (BOOL)isLessThanNumber:(CHNumber *)number;

/**
 Returns a boolean indicating whether the receiver is less than or equal to @a number.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param number another CHNumber
 @return @c YES if the receiver is less than or equal to @a number, @c NO otherwise.
 */
- (BOOL)isLessThanOrEqualToNumber:(CHNumber *)number;

/**
 Returns an NSComparisonResult indicating how the receiver compares to @a object.  This method uses the <a href="http://openssl.org/docs/crypto/BN_cmp.html">BN_cmp</a> to do its comparison.
 @param object a non-nil object
 @return NSOrderedAscending if the value of @a object is greater than the receiver’s, NSOrderedSame if they’re equal, and NSOrderedDescending if the value of @a object is less than the receiver’s.
 */
- (NSComparisonResult)compare:(id)object;

#pragma mark Mathematical Operations

/**
 Perform a modular division.  Returns a number n such that @c (receiver = k * mod + n).
 @param mod the number by which to divide
 @return a CHNumber
 */
- (CHNumber *)numberByModding:(CHNumber *)mod;

/**
 Perform an inverse modular division.  Returns a number r such that @c ((receiver * r) % mod == 1).
 @param mod a non-nil CHNumber
 @return a CHNumber
 */
- (CHNumber *)numberByInverseModding:(CHNumber *)mod;

- (CHNumber *)numberByAdding:(CHNumber *)addend;
- (CHNumber *)numberByAdding:(CHNumber *)addend mod:(CHNumber *)mod;

- (CHNumber *)numberBySubtracting:(CHNumber *)subtrahend;
- (CHNumber *)numberBySubtracting:(CHNumber *)subtrahend mod:(CHNumber *)mod;

- (CHNumber *)numberByMultiplyingBy:(CHNumber *)multiplicand;
- (CHNumber *)numberByMultiplyingBy:(CHNumber *)multiplicand mod:(CHNumber *)mod;

- (CHNumber *)numberByDividingBy:(CHNumber *)divisor;

- (CHNumber *)squaredNumber;
- (CHNumber *)squaredNumberMod:(CHNumber *)mod;

- (CHNumber *)numberByRaisingToPower:(CHNumber *)exponent;
- (CHNumber *)numberByRaisingToPower:(CHNumber *)exponent mod:(CHNumber *)mod;

- (CHNumber *)negatedNumber;

#pragma mark Bitfield Operations

- (BOOL)isBitSet:(NSUInteger)bit;
- (CHNumber *)numberByShiftingLeftOnce;
- (CHNumber *)numberByShiftingLeft:(NSUInteger)leftShift;
- (CHNumber *)numberByShiftingRightOnce;
- (CHNumber *)numberByShiftingRight:(NSUInteger)rightShift;
- (CHNumber *)numberByMaskingWithInteger:(NSUInteger)mask;

@end
