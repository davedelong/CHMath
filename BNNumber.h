//
//  BNNumber.h
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/bn.h>

@interface BNNumber : NSObject <NSCoding, NSCopying> {
	BIGNUM *bignum;
	BN_CTX *ctx;
}

@property(readonly) BIGNUM * bignum;

#pragma mark Initializers

+ (id)number;
+ (id)numberWithInteger:(NSInteger)integer;
+ (id)numberWithUnsignedInteger:(NSUInteger)integer;
+ (id)numberWithString:(NSString *)string;
+ (id)numberWithHexString:(NSString *)string;
+ (id)numberWithNumber:(NSNumber *)number;

- (id)initWithInteger:(NSInteger)integer;
- (id)initWithUnsignedInteger:(NSUInteger)integer;
- (id)initWithString:(NSString *)string;
- (id)initWithHexString:(NSString *)string;
- (id)initWithNumber:(NSNumber *)number;

#pragma mark Behavior

- (NSString *)hexStringValue;
- (NSString *)stringValue;
- (NSArray *)factors;

#pragma mark Comparisons

- (BOOL)isZero;
- (BOOL)isOne;
- (BOOL)isNegative;
- (BOOL)isPrime;
- (BOOL)isOdd;
- (BOOL)isEven;

- (BOOL)isGreaterThanNumber:(BNNumber *)number;
- (BOOL)isGreaterThanOrEqualToNumber:(BNNumber *)number;
- (BOOL)isEqualToNumber:(BNNumber *)number;
- (BOOL)isLessThanNumber:(BNNumber *)number;
- (BOOL)isLessThanOrEqualToNumber:(BNNumber *)number;
- (NSInteger)compareTo:(id)object;

#pragma mark Mathematical Operations
- (BNNumber *)numberByModding:(BNNumber *)mod;
- (BNNumber *)numberByInverseModding:(BNNumber *)mod;

- (BNNumber *)numberByAdding:(BNNumber *)addend;
- (BNNumber *)numberByAdding:(BNNumber *)addend mod:(BNNumber *)mod;

- (BNNumber *)numberBySubtracting:(BNNumber *)subtrahend;
- (BNNumber *)numberBySubtracting:(BNNumber *)subtrahend mod:(BNNumber *)mod;

- (BNNumber *)numberByMultiplingWith:(BNNumber *)multiplicand;
- (BNNumber *)numberByMultiplingWith:(BNNumber *)multiplicand mod:(BNNumber *)mod;

- (BNNumber *)numberByDividingWith:(BNNumber *)divisor;

- (BNNumber *)numberBySquaring;
- (BNNumber *)numberBySquaringMod:(BNNumber *)mod;

- (BNNumber *)numberByRaisingToPower:(BNNumber *)exponent;
- (BNNumber *)numberByRaisingToPower:(BNNumber *)exponent mod:(BNNumber *)mod;

#pragma mark Bitfield Operations

- (BOOL)isBitSet:(NSUInteger)bit;
- (BNNumber *)numberByShiftingLeftOnce;
- (BNNumber *)numberByShiftingLeft:(NSUInteger)leftShift;
- (BNNumber *)numberByShiftingRightOnce;
- (BNNumber *)numberByShiftingRight:(NSUInteger)rightShift;
- (BNNumber *)numberByMaskingWithInteger:(NSUInteger)mask;

@end
