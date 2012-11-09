//
//  PreferencesViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 16/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

@synthesize textCorpusPathTextField;
@synthesize iobCorpusPathTextField;
@synthesize iobRevisedCorpusPathTextField;
@synthesize grammarFilePathTextField;
@synthesize taggerFilePathTextField;
@synthesize textFilePathTextField;
@synthesize latexFilePathTextField;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self loadPreferences];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}


+ (NSString*)getStringForKey:(NSString*)key
{
    NSString* val = @"";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults stringForKey:key];
    if (val == NULL) val = @"";
    return val;
}

- (NSString*)getStringForKey:(NSString*)key
{
    NSString* val = @"";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults stringForKey:key];
    if (val == NULL) val = @"";
    return val;
}

- (void)setStringForKey:(NSString*)value:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
        NSLog(@"Syncronizing userdefaults");
	}
}


- (void)loadPreferences
{
    NSString *value = @"";
    //NSLog(@"Load preferences");
    
    value = [self getStringForKey:TEXT_CORPUS_PREFERENCE];
    [textCorpusPathTextField setStringValue: value];

    value = [self getStringForKey:IOB_CORPUS_PREFERENCE];
    [iobCorpusPathTextField setStringValue: value];
    
    value = [self getStringForKey:IOB_REVISED_CORPUS_PREFERENCE];
    [iobRevisedCorpusPathTextField setStringValue: value];
    
    value = [self getStringForKey:GRAMMAR_FILE_PREFERENCE];
    [grammarFilePathTextField setStringValue: value];
    
    value = [self getStringForKey:TAGGER_FILE_PREFERENCE];
    [taggerFilePathTextField setStringValue: value];
    
    value = [self getStringForKey:TEXT_FILE_PREFERENCE];
    [textFilePathTextField setStringValue: value];
    
    value = [self getStringForKey:LATEX_FILE_PREFERENCE];
    [latexFilePathTextField setStringValue: value];
    
}


/**
 A C T I O N S
 **/

- (IBAction)selecPathOpenPanel:(id)sender
{
    
    // Creating the open panel
    mSelectFileOpenPanel = [NSOpenPanel openPanel];
    [mSelectFileOpenPanel setCanChooseDirectories:YES];
    [mSelectFileOpenPanel setCanCreateDirectories:YES];
    
    NSString *customDirString = @"";
    
    if( [sender tag] == TEXT_CORPUS_FOLDER_TAG){
        [mSelectFileOpenPanel setTitle:@"Select Text Corpus folder: "];
        [mSelectFileOpenPanel setCanChooseFiles:NO];
        
        // Open the saved path
        if( ![[textCorpusPathTextField stringValue] isEqualTo:@""]){
            customDirString = [textCorpusPathTextField stringValue];
        }
        
    }
    else if( [sender tag] == IOB_CORPUS_FOLDER_TAG){
        [mSelectFileOpenPanel setTitle:@"Select IOB Corpus folder: "];
        [mSelectFileOpenPanel setCanChooseFiles:NO];
        
        // Opening the saved path
        if( ![[iobCorpusPathTextField stringValue] isEqualTo:@""]){
            customDirString = [iobCorpusPathTextField stringValue];
        }
    }
    else if( [sender tag] == IOB_REVISED_CORPUS_FOLDER_TAG){
        [mSelectFileOpenPanel setTitle:@"Select IOB REVISED Corpus folder: "];
        [mSelectFileOpenPanel setCanChooseFiles:NO];
        
        // Open the saved path
        if( ![[iobRevisedCorpusPathTextField stringValue] isEqualTo:@""]){
            customDirString = [iobRevisedCorpusPathTextField stringValue];
        }
    }
    else if( [sender tag] == GRAMMAR_RULES_FILE_TAG){
        [mSelectFileOpenPanel setCanChooseFiles:YES];
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"gr"]];
        [mSelectFileOpenPanel setTitle:@"Select Entities Rules file: (*.gr) "];
        
        // Open the saved path
        if( ![[grammarFilePathTextField stringValue] isEqualTo:@""]){
            customDirString = [grammarFilePathTextField stringValue];
        }
    }
    else if( [sender tag] == TAGGER_RULES_FILE_TAG ){
        [mSelectFileOpenPanel setCanChooseFiles:YES];
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"etq"]];
        [mSelectFileOpenPanel setTitle:@"Select Tag Rules file: (*.etq) "];
        
        // Open the saved path
        if( ![[taggerFilePathTextField stringValue] isEqualTo:@""]){
            customDirString = [taggerFilePathTextField stringValue];
        }
    }
    else if( [sender tag] == TEXT_FILE_TAG ){
        [mSelectFileOpenPanel setCanChooseFiles:YES];
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
        //[mSelectFolderOpenPanel setAccessoryView:openPanelExtraButtonsView];
        [mSelectFileOpenPanel setTitle:@"Select Text Output file: (*.txt) "];
        //[mSelectFileOpenPanel setAccessoryView: openPanelExtraButtonsView];
        
        // Open the saved path
        if( ![[textFilePathTextField stringValue] isEqualTo:@""]){
            customDirString = [textFilePathTextField stringValue];
        }
    }
    else if( [sender tag] == LATEX_FILE_TAG ){
        [mSelectFileOpenPanel setCanChooseFiles:YES];
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"tex"]];
        //[mSelectFolderOpenPanel setAccessoryView:openPanelExtraButtonsView];
        [mSelectFileOpenPanel setTitle:@"Select Latex Output file: (*.tex) "];
        //[mSelectFileOpenPanel setAccessoryView: openPanelExtraButtonsView];
        
        // Open the saved path
        if( ![[latexFilePathTextField stringValue] isEqualTo:@""]){
            customDirString = [latexFilePathTextField stringValue];
        }
    }
    
    // Customizing the path to open "select file/folder" window
    [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:customDirString]];
    NSInteger resultNSInteger = [mSelectFileOpenPanel runModal];

    NSURL *resultFile = nil;
    Boolean isFileSelected = NO;
    NSString *varFileString = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        NSLog(@"doOpen we have an OK button");
        
        // Gettin url file
        resultFile = [mSelectFileOpenPanel URL];
        // URL to string, cutting "file:/localhos..."
        varFileString= [[resultFile absoluteString] substringFromIndex:16];
        // Replacing white spaces
        varFileString = [Util removeBadWhiteSpaces:varFileString];
        
        isFileSelected = YES;
        
    }
    // Click on Cancel button
    else if(resultNSInteger == NSCancelButton){
        
        NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {
        
        NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",resultNSInteger);
        return;
    }
    
    if( isFileSelected ){
        
        varFileString = [Util replaceWhiteSpacesByScapeChar:varFileString];
        varFileString = [Util fixAccentInPathString:varFileString];
        //NSLog(@"hola %@", varFileString);

        
        switch ([sender tag]) {
            
            case TEXT_CORPUS_FOLDER_TAG:
                [textCorpusPathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :TEXT_CORPUS_PREFERENCE];
                break;
                
            case IOB_CORPUS_FOLDER_TAG:
                [iobCorpusPathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :IOB_CORPUS_PREFERENCE ];
                break;
                
            case IOB_REVISED_CORPUS_FOLDER_TAG:
                [iobRevisedCorpusPathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :IOB_REVISED_CORPUS_PREFERENCE ];
                break;
                
            case GRAMMAR_RULES_FILE_TAG:
                [grammarFilePathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :GRAMMAR_FILE_PREFERENCE];
                break;
                
            case TAGGER_RULES_FILE_TAG:
                [taggerFilePathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :TAGGER_FILE_PREFERENCE];
                break;
            
            case TEXT_FILE_TAG:
                [textFilePathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :TEXT_FILE_PREFERENCE];
                break;
            
            case LATEX_FILE_TAG:
                [latexFilePathTextField setStringValue: varFileString];
                [self setStringForKey:varFileString :LATEX_FILE_PREFERENCE ];
                break;
            
            default:
                break;
        }
        
    }
    
}

- (IBAction)createNewTxtFile:(id)sender
{
    
    // Point to Document directory
    NSString *folderPath = [[[mSelectFileOpenPanel directoryURL] absoluteString] substringFromIndex:16];
    
    NSString *filePath = [folderPath
                          stringByAppendingPathComponent: [newFilenameTextField stringValue]];
    //NSLog(@"%@", filePath);
    
    // String to write
    NSString *str = @"";
    
    // Write the file
    [str writeToFile:filePath atomically:YES
            encoding:NSUTF8StringEncoding error:nil];
}

@end