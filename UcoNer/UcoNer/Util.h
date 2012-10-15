//
//  Util.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 13/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int FOLDER_TAG = 1;
static const int GRAMMAR_RULES_FILE_TAG = 2;
static const int TAGGER_RULES_FILE_TAG = 3;
static const int TEXT_FILE_TAG = 4;
static const int LATEX_FILE_TAG = 5;

@interface Util : NSClassDescription

+ (NSString *)removeBadWhiteSpaces:(NSString *)pathString;

+ (NSString *)replaceWhiteSpacesByScapeChar:(NSString *)pathString;

@end
