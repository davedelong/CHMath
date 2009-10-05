//
//  CHUtils.m
//  CHMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "CHUtils.h"
#import "CHNumber.h"
#import "CHNumber_Private.h"
#import <openssl/bn.h>
#import <openssl/rand.h>

static NSMutableSet * cachedPrimes;


@implementation CHUtils

+ (void)initialize {
	@synchronized(self) {
		cachedPrimes = [[NSMutableSet alloc] init];
		NSFileHandle * random = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
		NSData * buffer = [random readDataOfLength:512];
		RAND_seed([buffer bytes], [buffer length]);
	}
}

+ (CHNumber *)generatePrimeOfLength:(NSUInteger)numBits safe:(BOOL)safe add:(CHNumber *)add remainder:(CHNumber *)rem {
	CHNumber * result = [CHNumber number];
	BN_generate_prime([result bigNumber], numBits, safe, [add bigNumber], [rem bigNumber], NULL, NULL);
	return result;
}

+ (CHNumber *)generatePrimeOfLength:(NSUInteger)numBits {
	return [CHUtils generatePrimeOfLength:numBits safe:NO add:nil remainder:nil];
}

+ (CHNumber *)generateSafePrimeOfLength:(NSUInteger)numBits {
	return [CHUtils generatePrimeOfLength:numBits safe:YES add:nil remainder:nil];
}

+ (CHNumber *)generatePrimeOfLength:(NSUInteger)numBits add:(CHNumber *)add remainder:(CHNumber *)rem {
	return [CHUtils generatePrimeOfLength:numBits safe:NO add:add remainder:rem];
}

+ (CHNumber *)generateSafePrimeOfLength:(NSUInteger)numBits add:(CHNumber *)add remainder:(CHNumber *)rem {
	return [CHUtils generatePrimeOfLength:numBits safe:YES add:add remainder:rem];
}

+ (CHNumber *)greatestCommonDivisorOf:(CHNumber *)first and:(CHNumber *)second {
	CHNumber * result = [CHNumber number];
	BN_CTX * ctx = BN_CTX_new();
	BN_gcd([result bigNumber], [first bigNumber], [second bigNumber], ctx);
	BN_CTX_free(ctx);
	return result;
}

+ (NSArray *)primesUpTo:(CHNumber *)number {
	CHNumber * two = [CHNumber numberWithInteger:2];
	if ([number isLessThanNumber:two]) { return [NSArray array]; }
	
	NSMutableArray * primes = [NSMutableArray arrayWithObject:two];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	CHNumber * potentialPrime = [CHNumber numberWithInteger:3];
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
