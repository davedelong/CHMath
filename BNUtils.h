//
//  BNUtils.h
//  BNMath
//
//  Created by Dave DeLong on 9/28/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNNumber;

@interface BNUtils : NSObject {

}

+ (BNNumber *)generatePrimeOfLength:(NSUInteger)numBits;
+ (BNNumber *)generateSafePrimeOfLength:(NSUInteger)numBits;
+ (BNNumber *)generatePrimeOfLength:(NSUInteger)numBits add:(BNNumber *)add remainder:(BNNumber *)rem;
+ (BNNumber *)generatePrimeOfLength:(NSUInteger)numBits add:(BNNumber *)add remainder:(BNNumber *)rem;

+ (BNNumber *)generatePrimeOfLength:(NSUInteger)numBits safe:(BOOL)safe add:(BNNumber *)add remainder:(BNNumber *)rem;

+ (BNNumber *)greatestCommonDivisorOf:(BNNumber *)first and:(BNNumber *)second;
+ (NSArray *)primesUpTo:(BNNumber *)number;

@end
