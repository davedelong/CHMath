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

+ (BNNumber *)greatestCommonDivisorOf:(BNNumber *)first and:(BNNumber *)second;
+ (NSArray *)primesUpTo:(BNNumber *)number;

@end
