//
//  CHTestUtils.h
//  CHMath
//
//  Created by Dave DeLong on 9/30/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CHMath.h"

#define ASSERTTRUE(expr,obj,sel) { \
STAssertTrue(expr, [NSString stringWithFormat:@"-[%@ %@] failed (%@)", [obj className], sel, obj]); \
}

#define ASSERTFALSE(expr,obj,sel) { \
STAssertFalse(expr, [NSString stringWithFormat:@"-[%@ %@] failed (%@)", [obj className], sel, obj]); \
}
