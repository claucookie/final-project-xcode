//
//  EvaluationViewController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 31/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EvaluationViewController : NSView{
    
    @private
    
    IBOutlet NSTableView *filesListTableView;
    IBOutlet NSButton *checkCorpusStepButton;
    IBOutlet NSButton *checkGrammarStepButton;
    IBOutlet NSButton *checkOutputFileStepButton;
    IBOutlet NSTextField *startEvaluationLabel;
    IBOutlet NSButton *startEvaluationButton;
    IBOutlet NSTextField *corpusFolderTextField;
    IBOutlet NSTextField *grammarFileTextField;
    IBOutlet NSButton *selectCorpusFolderButton;
    IBOutlet NSButton *selectGrammarFileButton;
    IBOutlet NSButton *selectOutputFileButton;
    IBOutlet NSTextView *evaluationResultTextView;
    IBOutlet NSTextField *logLabel;
    IBOutlet NSTextField *outputFileTextField;
    
    IBOutlet NSProgressIndicator *progressIndicator;
    
    
    NSURL *mCorpusURL;
    NSInteger mEvaluationSteps;
    NSMutableArray *mFilesListArray;
    
    // Variables to be used as arguments
    NSString *mCorpusPathString;
    NSString *mGrammarPathString;
    NSString *mOutputFilePathString;
    
    
}

@end
