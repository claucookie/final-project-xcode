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

+ (NSString *)fixAccentInPathString:(NSString *)pathString
{
    pathString = [pathString stringByReplacingOccurrencesOfString:@"a%CC%81" withString:@"á"];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"e%CC%81" withString:@"é"];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"i%CC%81" withString:@"í"];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"o%CC%81" withString:@"ó"];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"u%CC%81" withString:@"ú"];
    
    return pathString;
}
@end
