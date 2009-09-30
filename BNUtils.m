//
//  BNUtils.m
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BNUtils.h"
#import "BNNumber.h"
#import "BNNumber_Private.h"
#import <openssl/bn.h>

static NSMutableSet * cachedPrimes;


@implementation BNUtils

+ (void) initialize {
	@synchronized(self) {
		cachedPrimes = [[NSMutableSet alloc] init];
	}
}

+ (BNNumber *)greatestCommonDivisorOf:(BNNumber *)first and:(BNNumber *)second {
	BNNumber * result = [BNNumber number];
	BN_CTX * ctx = BN_CTX_new();
	BN_gcd([result bignum], [first bignum], [second bignum], ctx);
	BN_CTX_free(ctx);
	return result;
}

+ (NSArray *)primesUpTo:(BNNumber *)number {
	BNNumber * two = [BNNumber numberWithInteger:2];
	if ([number isLessThanNumber:two]) { return [NSArray array]; }
	
	NSMutableArray * primes = [NSMutableArray arrayWithObject:two];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	BNNumber * potentialPrime = [BNNumber numberWithInteger:3];
	while ([potentialPrime isLessThanNumber:number]) {
		if ([cachedPrimes containsObject:potentialPrime] == YES) {
			[primes addObject:potentialPrime];
		} else if ([potentialPrime isPrime]) {
			[cachedPrimes addObject:potentialPrime];
			[primes addObject:potentialPrime];
		}
		potentialPrime = [potentialPrime numberByAdding:two];
	}
	[pool release];
	return primes;
}

@end
