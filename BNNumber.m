//
//  BNNumber.m
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNNumber.h"
#import "BNUtils.h"
#import "BNNumber_Private.h"

@implementation BNNumber

@synthesize bignum;

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
		bignum = BN_new();
		if (bignum == NULL) {
			[self release];
			return nil;
		}
		BN_zero(bignum);
		ctx = BN_CTX_new();
		if(ctx == NULL) {
			BN_free(bignum);
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
			BN_set_word([self bignum], integer);
			//subtract the value twice to get the negative value
			BN_sub_word([self bignum], integer);
			BN_sub_word([self bignum], integer);
		} else {
			BN_set_word([self bignum], integer);
		}
    }
	return self;	
}

- (id)initWithUnsignedInteger:(NSUInteger)integer {
	if (self = [self init]) {
		BN_set_word(bignum, integer);
	}
	return self;
}

- (id)initWithString:(NSString *)string {
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * n = [f numberFromString:string];
	[f release];
	if (n == nil) { [self release]; return nil; }
	if (self = [self init]) {
		NSLocale * decimalLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		NSString * decimalString = [n descriptionWithLocale:decimalLocale];
		[decimalLocale release];
		BN_dec2bn(&bignum, [decimalString cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	return self;
}

- (id)initWithHexString:(NSString *)string {
	NSCharacterSet * hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
	NSRange nonHexChar = [string rangeOfCharacterFromSet:[hexSet invertedSet]];
	if (nonHexChar.location != NSNotFound) { [self release]; return nil; }
	if (self = [self init]) {
		BN_hex2bn(&bignum, [string cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	return self;
}

- (id)initWithNumber:(NSNumber *)number {
	return [self initWithString:[number descriptionWithLocale:[NSLocale currentLocale]]];
}

- (void) dealloc {
	BN_clear_free(bignum), bignum = NULL;
	BN_CTX_free(ctx), ctx = NULL;
	[super dealloc];
}

- (void) finalize {
	BN_clear_free(bignum), bignum = NULL;
	BN_CTX_free(ctx), ctx = NULL;
	[super finalize];
}

#pragma mark -
#pragma mark NSCopying compliance

- (id) copyWithZone:(NSZone *)zone {
	id copy = [[[self class] alloc] init];
	BN_copy([copy bignum], [self bignum]);
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
	return [NSString stringWithCString:BN_bn2dec([self bignum]) encoding:NSUTF8StringEncoding];
}

- (NSString *)hexStringValue {
	return [NSString stringWithCString:BN_bn2hex([self bignum]) encoding:NSUTF8StringEncoding];
}

- (NSString *)binaryStringValue {
	NSUInteger numBytes = BN_num_bytes([self bignum]);
	unsigned char * string = malloc(numBytes * sizeof(unsigned char));
	int len = BN_bn2bin([self bignum], string);
	for (int i = 0; i < len; ++i) {
		NSLog(@"%c", string[i]);
	}
	NSString * binaryString = [[NSString alloc] initWithBytesNoCopy:string length:len encoding:NSASCIIStringEncoding freeWhenDone:YES];
	NSLog(@"Bin: %@", binaryString);
	return [binaryString autorelease];
}

- (NSInteger)integerValue {
	NSInteger value = BN_get_word([self bignum]);
	if ([self isNegative]) { value *= -1; }
	return value;
}

- (NSUInteger)unsignedIntegerValue {
	return (NSUInteger)BN_get_word([self bignum]);
}

- (NSString *)description {
	return [self stringValue];
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"%@ - %@", [self className], [self stringValue]];
}

#pragma mark Comparisons

- (BOOL)isZero {
	return BN_is_zero([self bignum]);
}

- (BOOL)isOne {
	return BN_is_one([self bignum]);
}

- (BOOL)isNegative {
	return [self isLessThanNumber:[BNNumber number]];
}

- (BOOL)isPositive {
	return ![self isNegative];
}

- (BOOL)isPrime {
	return BN_is_prime([self bignum], BN_prime_checks, NULL, ctx, NULL);
}

- (BOOL)isOdd {
	return BN_is_odd([self bignum]);
}

- (BOOL)isEven {
	return ![self isOdd];
}

- (BOOL)isGreaterThanNumber:(BNNumber *)number {
	return (BN_cmp([self bignum], [number bignum]) == NSOrderedDescending);
}

- (BOOL)isGreaterThanOrEqualToNumber:(BNNumber *)number {
	return ([self isGreaterThanNumber:number] || [self isEqualToNumber:number]);
}

- (NSInteger) compareTo:(id)object {
	if ([object isKindOfClass:[self class]]) {
		BNNumber * other = (BNNumber *)object;
		return BN_cmp([self bignum], [other bignum]);
	}
	return NSOrderedDescending;
}

- (BOOL)isEqualToNumber:(BNNumber *)number {
	return (BN_cmp([self bignum], [number bignum]) == NSOrderedSame);
}

- (BOOL)isLessThanNumber:(BNNumber *)number {
	return (BN_cmp([self bignum], [number bignum]) == NSOrderedAscending);	
}

- (BOOL)isLessThanOrEqualToNumber:(BNNumber *)number {
	return ([self isLessThanNumber:number] || [self isEqualToNumber:number]);
}

- (BOOL) isEqualTo:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self isEqualToNumber:(BNNumber *)object];
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
	NSArray * primes = [BNUtils primesUpTo:self];
	BNNumber * copy = [[self copy] autorelease];
	for (BNNumber * prime in primes) {
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

- (BNNumber *)numberByModding:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod([result bignum], [self bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberByInverseModding:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_inverse([result bignum], [self bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberByAdding:(BNNumber *)addend {
	BNNumber * result = [BNNumber number];
	BN_add([result bignum], [self bignum], [addend bignum]);
	return result;
}

- (BNNumber *)numberByAdding:(BNNumber *)addend mod:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_add([result bignum], [self bignum], [addend bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberBySubtracting:(BNNumber *)subtrahend {
	BNNumber * result = [BNNumber number];
	BN_sub([result bignum], [self bignum], [subtrahend bignum]);
	return result;
}

- (BNNumber *)numberBySubtracting:(BNNumber *)subtrahend mod:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_sub([result bignum], [self bignum], [subtrahend bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberByMultiplyingBy:(BNNumber *)multiplicand {
	BNNumber * result = [BNNumber number];
	BN_mul([result bignum], [self bignum], [multiplicand bignum], ctx);
	return result;
}

- (BNNumber *)numberByMultiplyingBy:(BNNumber *)multiplicand mod:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_mul([result bignum], [self bignum], [multiplicand bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberByDividingBy:(BNNumber *)divisor {
	BNNumber * result = [BNNumber number];
	BN_div([result bignum], NULL, [self bignum], [divisor bignum], ctx);
	return result;
}

- (BNNumber *)squaredNumber {
	BNNumber * result = [BNNumber number];
	BN_sqr([result bignum], [self bignum], ctx);
	return result;
}

- (BNNumber *)squaredNumberMod:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_sqr([result bignum], [self bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)numberByRaisingToPower:(BNNumber *)exponent {
	BNNumber * result = [BNNumber number];
	BN_exp([result bignum], [self bignum], [exponent bignum], ctx);
	return result;
}

- (BNNumber *)numberByRaisingToPower:(BNNumber *)exponent mod:(BNNumber *)mod {
	BNNumber * result = [BNNumber number];
	BN_mod_exp([result bignum], [self bignum], [exponent bignum], [mod bignum], ctx);
	return result;
}

- (BNNumber *)negatedNumber {
	BNNumber * result = [self copy];
	BN_set_negative([result bignum], ![self isNegative]);
	return [result autorelease];
}

#pragma mark Bitfield Operations

- (BOOL)isBitSet:(NSUInteger)bit {
	return BN_is_bit_set([self bignum], bit);
}

- (BNNumber *)numberByShiftingLeftOnce {
	BNNumber * result = [BNNumber number];
	BN_lshift1([result bignum], [self bignum]);
	return result;
}

- (BNNumber *)numberByShiftingLeft:(NSUInteger)leftShift {
	BNNumber * result = [BNNumber number];
	BN_lshift([result bignum], [self bignum], leftShift);
	return result;
}

- (BNNumber *)numberByShiftingRightOnce {
	BNNumber * result = [BNNumber number];
	BN_rshift1([result bignum], [self bignum]);
	return result;
}

- (BNNumber *)numberByShiftingRight:(NSUInteger)rightShift {
	BNNumber * result = [BNNumber number];
	BN_rshift([result bignum], [self bignum], rightShift);
	return result;
}

- (BNNumber *)numberByMaskingWithInteger:(NSUInteger)mask {
	BNNumber * result = [self copy];
	BN_mask_bits([result bignum], mask);
	return [result autorelease];
}

@end
