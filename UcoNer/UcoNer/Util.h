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
FOUNDATION_EXPORT int *const FolderTypeTag;
FOUNDATION_EXPORT int *const EntityRulesFileTypeTag;
FOUNDATION_EXPORT int *const TaggerRulesFileTypeTag;
FOUNDATION_EXPORT int *const TxtFileTypeTag;
FOUNDATION_EXPORT int *const TexFileTypeTag;

+ (NSString *)removeBadWhiteSpaces:(NSString *)pathString;

+ (NSString *)replaceWhiteSpacesByScapeChar:(NSString *)pathString;

@end
