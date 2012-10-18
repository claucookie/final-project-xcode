//
//  RecognitionViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 30/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"
#import "Util.h"
#import "PreferencesViewController.h"

@class PMProgressTextView;

@interface RecognitionViewController : NSView{
    
    @private
    
    // Recognition View : fields and buttons
    IBOutlet NSTextField *recogInCorpusDirTextField;
    IBOutlet NSTableView *recogFilesListTableView;
    IBOutlet NSTextField *selectedFileTextField;
    IBOutlet NSTextField *recogGrammarFileTextField;
    IBOutlet NSTextField *recogTaggerFileTextField;
    IBOutlet NSTextView *recogFileContentTextField;
    IBOutlet NSTextField *entitiesListFileTextField;
    IBOutlet NSTextField *logLabel;
    IBOutlet NSButton *recogCheckCorpus;
    IBOutlet NSButton *recogCheckFile;
    IBOutlet NSButton *recogCheckTagger;
    IBOutlet NSButton *recogCheckGrammar;
    IBOutlet NSButton *recogCheckOutputFile;
    IBOutlet NSButton *startRecognitionButton;
    IBOutlet NSTextField *startRecognitionLabel;
    IBOutlet NSButton *corpusToggleButton;
    IBOutlet NSButton *fileToggleButton;
    
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSView *openPanelExtraButtonsView;
    IBOutlet NSTextField *newFilenameTextField;
    
    NSOpenPanel *mSelectFolderOpenPanel;
    NSOpenPanel *mSelectFileOpenPanel;
    NSMutableArray *mFilesListArray;
    NSURL *mCorpusFolderURL;
    NSURL *mFileURL;
    NSInteger mRecogSteps;
    Boolean mCorpusOrFileToggleButtonWasClickedYet;
    
    // Variables to be used as arguments
    NSString *mCorpusPathString;
    NSString *mGrammarPathString;
    NSString *mTaggerPathString;
    NSString *mOutputFilePathString;
    
    
    

    
}

@end
