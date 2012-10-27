//
//  Util.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 13/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

// BUTTON TAGS
static const int FOLDER_TAG = 1;
static const int GRAMMAR_RULES_FILE_TAG = 2;
static const int TAGGER_RULES_FILE_TAG = 3;
static const int TEXT_FILE_TAG = 4;
static const int LATEX_FILE_TAG = 5;
static const int TEXT_CORPUS_FOLDER_TAG = 6;
static const int IOB_CORPUS_FOLDER_TAG = 7;
static const int IOB_REVISED_CORPUS_FOLDER_TAG = 8;

// USER DEFAULT PREFERENCES
static NSString *TEXT_CORPUS_PREFERENCE = @"textCorpusPathPref";
static NSString *IOB_CORPUS_PREFERENCE = @"iobCorpusPathPref";
static NSString *IOB_REVISED_CORPUS_PREFERENCE = @"iobRevisedCorpusPathPref";
static NSString *GRAMMAR_FILE_PREFERENCE = @"grammarFilePathPref";
static NSString *TAGGER_FILE_PREFERENCE = @"taggerFilePathPref";
static NSString *TEXT_FILE_PREFERENCE = @"textFilePathPref";
static NSString *LATEX_FILE_PREFERENCE = @"latexFilePathPref";


@interface Util : NSClassDescription

+ (NSString *)removeBadWhiteSpaces:(NSString *)pathString;

+ (NSString *)replaceWhiteSpacesByScapeChar:(NSString *)pathString;

+ (NSString *)fixAccentInPathString:(NSString *)pathString;

@end
