//
//  Util.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 13/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)removeBadWhiteSpaces:(NSString *)pathString
{
    return [pathString stringByReplacingOccurrencesOfString:@"%20"
                                            withString:@"\ "];
}

+ (NSString *)replaceWhiteSpacesByScapeChar:(NSString *)pathString
{
    return [pathString stringByReplacingOccurrencesOfString:@" " withString:@"\ "];
}
@end
