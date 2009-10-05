//
//  CHNumber.m
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHNumber.h"
#import "CHUtils.h"
#import "CHNumber_Private.h"

#define CH_ASCII_ZERO 48

@interface CHNumber ()

@property (readonly) BIGNUM * bigNumber;

@end


@implementation CHNumber

@synthesize bigNumber;

+ (id)numberWithInteger:(NSInteger)integer {
	return [[[[self class] alloc] initWithInteger:integer] autorelease];
}

+ (id)numberWithUnsignedInteger:(NSUInteger)integer {
	return [[[[self class] alloc] initWithUnsignedInteger:integer] autorelease];
}

+ (id)numberWithString:(NSString *)string {
	return [[[[self class] alloc] initWithString:string] autorelease];
}

+ (id)numberWithHexString:(NSString *)string {
	return [[[[self class] alloc] initWithHexString:string] autorelease];
}

+ (id)numberWithNumber:(NSNumber *)number {
	return [[[[self class] alloc] initWithNumber:number] autorelease];
}

+ (id)number {
	return [[[[self class] alloc] initWithInteger:0] autorelease];
}

- (id) init {
	if (self = [super init]) {
		bigNumber = BN_new();
		if (bigNumber == NULL) {
			[self release];
			return nil;
		}
		BN_zero(bigNumber);
		context = BN_CTX_new();
		if(context == NULL) {
			BN_free(bigNumber);
			[self release];
			return nil;
		}
	}
	return self;	
}

- (id)initWithInteger:(NSInteger)integer {
	if(self = [self init]) {
		if (integer < 0) {
			integer *= -1;
			//set the initial value to the positive value
			BN_set_word([self bigNumber], integer);
			//subtract the value twice to get the negative value
			BN_sub_word([self bigNumber], integer);
			BN_sub_word([self bigNumber], integer);
		} else {
			BN_set_word([self bigNumber], integer);
		}
    }
	return self;	
}

- (id)initWithUnsignedInteger:(NSUInteger)integer {
	if (self = [self init]) {
		BN_set_word(bigNumber, integer);
	}
	return self;
}

- (id)initWithString:(NSString *)string {
	NSCharacterSet * decSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
	NSRange nonDecChar = [string rangeOfCharacterFromSet:[decSet invertedSet]];
	if (nonDecChar.location != NSNotFound) { [self release]; return nil; }
	if (self = [self init]) {
		BN_dec2bn(&bigNumber, [string cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	return self;
}

- (id)initWithHexString:(NSString *)string {
	NSCharacterSet * hexSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789abcdefABCDEF"];
	NSRange nonHexChar = [string rangeOfCharacterFromSet:[hexSet invertedSet]];
	if (nonHexChar.location != NSNotFound) { [self release]; return nil; }
	if (self = [self init]) {
		BN_hex2bn(&bigNumber, [string cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	return self;
}

- (id)initWithNumber:(NSNumber *)number {
	return [self initWithString:[number descriptionWithLocale:[NSLocale currentLocale]]];
}

- (void) dealloc {
	BN_clear_free(bigNumber), bigNumber = NULL;
	BN_CTX_free(context), context = NULL;
	[super dealloc];
}

- (void) finalize {
	BN_clear_free(bigNumber), bigNumber = NULL;
	BN_CTX_free(context), context = NULL;
	[super finalize];
}

#pragma mark -
#pragma mark NSCopying compliance

- (id) copyWithZone:(NSZone *)zone {
	id copy = [[[self class] alloc] init];
	BN_copy([copy bigNumber], [self bigNumber]);
	return copy;
}

#pragma mark -
#pragma mark NSCoding compliance

- (id) initWithCoder:(NSCoder *)decoder {
	return [self initWithString:[decoder decodeObjectForKey:@"num"]];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:[self stringValue] forKey:@"num"];
}

#pragma mark -
#pragma mark Getters and Setters

- (NSString *)stringValue {
	return [NSString stringWithCString:BN_bn2dec([self bigNumber]) encoding:NSASCIIStringEncoding];
}

- (NSString *)hexStringValue {
	return [NSString stringWithCString:BN_bn2hex([self bigNumber]) encoding:NSASCIIStringEncoding];
}

- (NSString *)binaryStringValue {
	NSUInteger numBits = BN_num_bits([self bigNumber]);
	BOOL isNegative = [self isNegative];
	BOOL shouldFlip = NO;
	NSUInteger totalBufferSize = numBits + 1;
	unsigned char * string = malloc(totalBufferSize * sizeof(unsigned char));
	string[totalBufferSize] = '\0';
	for (int i = 0; i < numBits; ++i) {
		int idx = totalBufferSize - i - 1;
		int bit = BN_is_bit_set([self bigNumber], i);
		if (isNegative) {
			if (shouldFlip == YES) {
				bit = !bit;
			} else if (bit == 1) {
				shouldFlip = YES;
			}
		}
		string[idx] = bit + CH_ASCII_ZERO;
	}
	string[0] = (int)isNegative + CH_ASCII_ZERO;
	NSString * binaryString = [[NSString alloc] initWithBytesNoCopy:string length:totalBufferSize encoding:NSASCIIStringEncoding freeWhenDone:YES];
	return [binaryString autorelease];
}

- (NSInteger)integerValue {
	NSInteger value = BN_get_word([self bigNumber]);
	if ([self isNegative]) { value *= -1; }
	return value;
}

- (NSUInteger)unsignedIntegerValue {
	return (NSUInteger)BN_get_word([self bigNumber]);
}

- (NSString *)description {
	return [self stringValue];
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"%@ - %@", [self className], [self stringValue]];
}

#pragma mark Comparisons

- (BOOL)isZero {
	return BN_is_zero([self bigNumber]);
}

- (BOOL)isOne {
	return BN_is_one([self bigNumber]);
}

- (BOOL)isNegative {
	return [self isLessThanNumber:[CHNumber number]];
}

- (BOOL)isPositive {
	return ![self isNegative];
}

- (BOOL)isPrime {
	return BN_is_prime([self bigNumber], BN_prime_checks, NULL, context, NULL);
}

- (BOOL)isOdd {
	return BN_is_odd([self bigNumber]);
}

- (BOOL)isEven {
	return ![self isOdd];
}

- (BOOL)isGreaterThanNumber:(CHNumber *)number {
	return (BN_cmp([self bigNumber], [number bigNumber]) == NSOrderedDescending);
}

- (BOOL)isGreaterThanOrEqualToNumber:(CHNumber *)number {
	return ([self isGreaterThanNumber:number] || [self isEqualToNumber:number]);
}

- (NSComparisonResult) compare:(id)object {
	if ([object isKindOfClass:[CHNumber class]]) {
		CHNumber * other = (CHNumber *)object;
		return (NSComparisonResult)BN_cmp([self bigNumber], [other bigNumber]);
	}
	return NSOrderedDescending;
}

- (BOOL)isEqualToNumber:(CHNumber *)number {
	return (BN_cmp([self bigNumber], [number bigNumber]) == NSOrderedSame);
}

- (BOOL)isLessThanNumber:(CHNumber *)number {
	return (BN_cmp([self bigNumber], [number bigNumber]) == NSOrderedAscending);	
}

- (BOOL)isLessThanOrEqualToNumber:(CHNumber *)number {
	return ([self isLessThanNumber:number] || [self isEqualToNumber:number]);
}

- (BOOL) isEqualTo:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self isEqualToNumber:(CHNumber *)object];
	} else {
		return [super isEqualTo:object];
	}
}

- (BOOL) isEqual:(id)object {
	return [self isEqualTo:object];
}

- (NSArray *)factors {
	NSMutableArray * factors = [NSMutableArray array];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * primes = [CHUtils primesUpTo:self];
	CHNumber * copy = [[self copy] autorelease];
	for (CHNumber * prime in primes) {
		while([[copy numberByModding:prime] isZero]) {
			[factors addObject:prime];
			copy = [copy numberByDividingBy:prime];
		}
		if ([copy isOne]) { break; }
	}
	[pool release];
	return factors;
}

#pragma mark -
#pragma mark Mathematical Operations

- (CHNumber *)numberByModding:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod([result bigNumber], [self bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberByInverseModding:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_inverse([result bigNumber], [self bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberByAdding:(CHNumber *)addend {
	CHNumber * result = [CHNumber number];
	BN_add([result bigNumber], [self bigNumber], [addend bigNumber]);
	return result;
}

- (CHNumber *)numberByAdding:(CHNumber *)addend mod:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_add([result bigNumber], [self bigNumber], [addend bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberBySubtracting:(CHNumber *)subtrahend {
	CHNumber * result = [CHNumber number];
	BN_sub([result bigNumber], [self bigNumber], [subtrahend bigNumber]);
	return result;
}

- (CHNumber *)numberBySubtracting:(CHNumber *)subtrahend mod:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_sub([result bigNumber], [self bigNumber], [subtrahend bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberByMultiplyingBy:(CHNumber *)multiplicand {
	CHNumber * result = [CHNumber number];
	BN_mul([result bigNumber], [self bigNumber], [multiplicand bigNumber], context);
	return result;
}

- (CHNumber *)numberByMultiplyingBy:(CHNumber *)multiplicand mod:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_mul([result bigNumber], [self bigNumber], [multiplicand bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberByDividingBy:(CHNumber *)divisor {
	CHNumber * result = [CHNumber number];
	BN_div([result bigNumber], NULL, [self bigNumber], [divisor bigNumber], context);
	return result;
}

- (CHNumber *)squaredNumber {
	CHNumber * result = [CHNumber number];
	BN_sqr([result bigNumber], [self bigNumber], context);
	return result;
}

- (CHNumber *)squaredNumberMod:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_sqr([result bigNumber], [self bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)numberByRaisingToPower:(CHNumber *)exponent {
	CHNumber * result = [CHNumber number];
	BN_exp([result bigNumber], [self bigNumber], [exponent bigNumber], context);
	return result;
}

- (CHNumber *)numberByRaisingToPower:(CHNumber *)exponent mod:(CHNumber *)mod {
	CHNumber * result = [CHNumber number];
	BN_mod_exp([result bigNumber], [self bigNumber], [exponent bigNumber], [mod bigNumber], context);
	return result;
}

- (CHNumber *)negatedNumber {
	CHNumber * result = [self copy];
	BN_set_negative([result bigNumber], ![self isNegative]);
	return [result autorelease];
}

#pragma mark Bitfield Operations

- (BOOL)isBitSet:(NSUInteger)bit {
	return BN_is_bit_set([self bigNumber], bit);
}

- (CHNumber *)numberByShiftingLeftOnce {
	CHNumber * result = [CHNumber number];
	BN_lshift1([result bigNumber], [self bigNumber]);
	return result;
}

- (CHNumber *)numberByShiftingLeft:(NSUInteger)leftShift {
	CHNumber * result = [CHNumber number];
	BN_lshift([result bigNumber], [self bigNumber], leftShift);
	return result;
}

- (CHNumber *)numberByShiftingRightOnce {
	CHNumber * result = [CHNumber number];
	BN_rshift1([result bigNumber], [self bigNumber]);
	return result;
}

- (CHNumber *)numberByShiftingRight:(NSUInteger)rightShift {
	CHNumber * result = [CHNumber number];
	BN_rshift([result bigNumber], [self bigNumber], rightShift);
	return result;
}

- (CHNumber *)numberByMaskingWithInteger:(NSUInteger)mask {
	CHNumber * result = [self copy];
	BN_mask_bits([result bigNumber], mask);
	return [result autorelease];
}

@end
