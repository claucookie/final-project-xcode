//
//  PreferencesViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 16/10/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Util.h"

@interface PreferencesViewController : NSView{
    
    @private
    NSOpenPanel *mSelectFileOpenPanel;
    
    NSString *favoriteCorpusTxtFolder;
    
    IBOutlet NSView *openPanelExtraButtonsView;
    IBOutlet NSTextField *newFilenameTextField;
    
}

@property (assign) IBOutlet NSTextField *textCorpusPathTextField;
@property (assign) IBOutlet NSTextField *iobCorpusPathTextField;
@property (assign) IBOutlet NSTextField *iobRevisedCorpusPathTextField;
@property (assign) IBOutlet NSTextField *grammarFilePathTextField;
@property (assign) IBOutlet NSTextField *taggerFilePathTextField;
@property (assign) IBOutlet NSTextField *textFilePathTextField;
@property (assign) IBOutlet NSTextField *latexFilePathTextField;
@property (assign) IBOutlet NSTextField *latexAppPathTextField;
@property (assign) IBOutlet NSTextField *textAppPathTextField;



+ (NSString*)getStringForKey:(NSString*)key;

@end
