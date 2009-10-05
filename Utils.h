//
//  Utils.h
//  CHMath
//
//  Created by Dave DeLong on 10/3/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Foundation/NSString.h>

/**
 @file Utils.h
 
 A group of utility C functions for simplifying common behavior and logging.
 */

/**
 Provides a terse alternative to NSLog() and accepts the same parameters. The output is made shorter by excluding the date stamp and process information which NSLog prints before the actual specified output.
 
 @param format A format string, which must not be nil.
 @param ... A comma-separated list of arguments to substitute into @a format.
 
 Read <strong>Formatting String Objects</strong> and <strong>String Format Specifiers</strong> on <a href="http://developer.apple.com/documentation/Cocoa/Conceptual/Strings/">this webpage</a> for details about using format strings. Look for examples that use @c NSLog() since the parameters and syntax are idential.
 */
OBJC_EXPORT void CHQuietLog(NSString *format, ...);

/**
 A macro for including the source file and line number where a log occurred.
 
 @param format A format string, which must not be nil.
 @param ... A comma-separated list of arguments to substitute into @a format.
 
 This is defined as a compiler macro so it can automatically fill in the file name and line number where the call was made. After printing these values in brackets, this macro calls #CHQuietLog with @a format and any other arguments supplied afterward.
 
 @see CHQuietLog
 */
#ifndef CHLocationLog
#define CHLocationLog(format,...) \
{ \
NSString *file = [[NSString alloc] initWithUTF8String:__FILE__]; \
printf("[%s:%d] ", [[file lastPathComponent] UTF8String], __LINE__); \
[file release]; \
CHQuietLog((format),##__VA_ARGS__); \
}
#endif
