//
//  FinderViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 29/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Util.h"

@interface FinderViewController : NSView{
    
    @private
    
    IBOutlet NSTextField *finderTitleLabel;
    
    // Interface items
    IBOutlet NSTextField *corpusFolderTextField;
    IBOutlet NSTableView *filesListTableView;
    IBOutlet NSTextField *regularExpressionTextField;
    IBOutlet NSButton *checkCorpusStepButton;
    IBOutlet NSButton *checkFileStepButton;
    IBOutlet NSButton *checkRegExpStepButton;
    IBOutlet NSButton *startSearchButton;
    IBOutlet NSTextField *startSearchLabel;
    IBOutlet NSTextField *outputFileTextField;
    IBOutlet NSTextView *finderResultTextView;
    IBOutlet NSTextField *logLabel;
    IBOutlet NSButton *openResultButton;
    
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSView *openPanelExtraButtonsView;
    IBOutlet NSTextField *newFilenameTextField;
    
    // Global use variables
    NSMutableArray *mFilesListArray;
    NSURL *mCorpusURL;
    NSURL *mFileURL;
    NSInteger mFinderSteps;
    Boolean mCorpusOrFileToggleButtonWasClickedYet;
    Boolean mRegularExpresionWasWrittenYet;
    NSOpenPanel *mSelectFileOpenPanel;
    NSOpenPanel *mSelectFolderOpenPanel;
    
    // 
    NSString *mOutputFilePathString;
    NSString *mInCorpusPathString;
    NSString *mRegexpString;

}

@end
