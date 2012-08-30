//
//  FinderViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 29/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FinderViewController : NSView{
    
    @private
    // Interface items
    IBOutlet NSTextField *corpusFolderTextField;
    IBOutlet NSTextField *selectedFileTextField;
    IBOutlet NSTableView *filesListTableView;
    IBOutlet NSButton *corpusToggleButton;
    IBOutlet NSTextField *regularExpressionTextField;
    IBOutlet NSButton *fileToggleButton;
    IBOutlet NSButton *checkCorpusStepButton;
    IBOutlet NSButton *checkFileStepButton;
    IBOutlet NSButton *checkRegExpStepButton;
    IBOutlet NSButton *checkCorpusOrFileStepButton;
    IBOutlet NSButton *startSearchButton;
    IBOutlet NSTextField *startSearchLabel;
    
    // Global use variables
    NSMutableArray *mFilesListArray;
    NSURL *mCorpusURL;
    NSURL *mFileURL;
    NSInteger mFinderSteps;
    Boolean mCorpusOrFileToggleButtonWasClickedYet;
    Boolean mRegularExpresionWasWrittenYet;

}

@end
