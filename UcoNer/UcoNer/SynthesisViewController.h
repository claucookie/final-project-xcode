//
//  SynthesisViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 01/09/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Util.h"

@interface SynthesisViewController : NSView{
    
    @private
    
    IBOutlet NSButton *checkCorpusStepButton;
    IBOutlet NSButton *checkGrammarStepButton;
    IBOutlet NSTextField *startSynthesisLabel;
    IBOutlet NSButton *startSynthesisButton;
    IBOutlet NSTextField *corpusFolderTextField;
    IBOutlet NSButton *corpusFolderButton;
    IBOutlet NSTextField *grammarFileTextField;
    IBOutlet NSButton *grammarFileButton;
    IBOutlet NSTableView *filesListTableView;
    IBOutlet NSTextView *synthesisResultTextView;
    IBOutlet NSTextField *logLabel;
    
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSView *openPanelExtraButtonsView;
    IBOutlet NSTextField *newFilenameTextField;
    
    NSMutableArray *mFilesListArray;
    NSInteger mSynthesisSteps;
    NSURL *mCorpusURL;
    NSString *mCorpusPathString;
    NSString *mTexFilePathString;
    NSOpenPanel *mSelectFileOpenPanel;
    NSOpenPanel *mSelectFolderOpenPanel;
}

@end
