//
//  Util.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 13/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSClassDescription

// Constans
FOUNDATION_EXPORT int FolderTypeTAG;
FOUNDATION_EXPORT int EntityRulesFileTypeTAG;
FOUNDATION_EXPORT int TaggerRulesFileTypeTAG;
FOUNDATION_EXPORT int TxtFileTypeTAG;
FOUNDATION_EXPORT int TexFileTypeTAG;

+ (NSString *)removeBadWhiteSpaces:(NSString *)pathString;

+ (NSString *)replaceWhiteSpacesByScapeChar:(NSString *)pathString;

@end
