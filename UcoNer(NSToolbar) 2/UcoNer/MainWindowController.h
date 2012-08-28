//
//  MainWindowController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 18/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController {
    
@private
    IBOutlet NSView *recognition;
    IBOutlet NSView *evaluation;
    IBOutlet NSView *finder;
    IBOutlet NSView *synthesis;
    
    int currentViewTag;
    
    // Recognition View : fields and buttons
    IBOutlet NSTextField *recogInCorpusDirTextField;
    IBOutlet NSTableView *recogFilesListTableView;
    IBOutlet NSTextField *recogFileSelectedTextField;
    IBOutlet NSTextField *recogGrammarFileTextField;
    IBOutlet NSTextField *recogTaggerFileTextField;
    IBOutlet NSTextField *recogFileContentTextField;
    IBOutlet NSButton *recogCheckCorpus;
    IBOutlet NSButton *recogCheckFile;
    IBOutlet NSButton *recogCheckTagger;
    IBOutlet NSButton *recogCheckGrammar;
    NSMutableArray *recogFilesListMArray;
    NSURL *recogCorpusURL;
    NSURL *recogFileURL;
    
}

- (IBAction)switchView:(id)sender;

/**
 Recognition methods, outlets
 */


@end
