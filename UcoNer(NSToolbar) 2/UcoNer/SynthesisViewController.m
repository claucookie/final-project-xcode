//
//  SynthesisViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 01/09/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "SynthesisViewController.h"

@implementation SynthesisViewController

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
    // Initalize fileListTableView
    [filesListTableView setDataSource:self];
    
    // Steps counter = 0
    mSynthesisSteps = 0;

}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)checkSynthesisSteps
{
    
    if(mSynthesisSteps == 2){
        [startSynthesisButton setEnabled:YES];
        [startSynthesisLabel setHidden:NO];
    }
    NSLog(@"%ld", mSynthesisSteps);
}


/**
 
 Actions
 
 **/

- (IBAction)startSynthesisTask:(id)sender
{
    // TODO:
}

- (IBAction)openSelectFolderPanel:(id)sender
{
    
    // Creating the open panel
    NSOpenPanel *tvarOp = [NSOpenPanel openPanel];
    [tvarOp setCanChooseDirectories:YES];
    [tvarOp setCanChooseFiles:FALSE];
    
    // Showing the panel
    NSInteger resultNSInteger = [tvarOp runModal];
    
    NSURL *resultDirectory = nil;
    Boolean isCorpusFolderSelected = NO;
    NSString *varCorpusDir = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        NSLog(@"doOpen we have an OK button");
        
        // Gettin url folder
        resultDirectory = [tvarOp directoryURL];
        mCorpusURL = resultDirectory;
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];
        
        NSLog(@"%@", varCorpusDir);
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[corpusFolderTextField stringValue] isEqualToString:@""] ){
            // Step done
            mSynthesisSteps++;
        }
        
        [corpusFolderTextField setStringValue:varCorpusDir];
        isCorpusFolderSelected = YES;
        
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
    
    if( isCorpusFolderSelected ){
        
        // LOADING files list array into Table view
        NSArray *filesArray = [[NSArray alloc] init];
        filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:varCorpusDir error:nil];
        
        mFilesListArray = [[NSMutableArray alloc] init];
        [mFilesListArray addObjectsFromArray:filesArray];
        
        
        // Loading files
        [filesListTableView reloadData];
        
        // Step done
        [checkCorpusStepButton setState:1];
        [self checkSynthesisSteps];
        
    }
}

- (IBAction)openSelectFilePanel:(id)sender
{
    
    // Creating the open panel
    NSOpenPanel *tvarOp = [NSOpenPanel openPanel];
    [tvarOp setCanChooseDirectories:NO];
    [tvarOp setCanChooseFiles:YES];
    [tvarOp setAllowedFileTypes:[NSArray arrayWithObject:@"gr"]];
    
    // Showing the panel
    
    NSInteger resultNSInteger = [tvarOp runModal];
    
    
    NSURL *resultFile = nil;
    Boolean isFileSelected = NO;
    NSString *varFileString = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        NSLog(@"doOpen we have an OK button");
        
        
        // Gettin url file
        resultFile = [tvarOp URL];
        
        // URL to string, cutting "file:/localhos..."
        varFileString= [[resultFile absoluteString] substringFromIndex:16];
        
        NSLog(@"%@", varFileString);
        
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
        
        if( [[grammarFileTextField stringValue] length] == 0 )
            mSynthesisSteps++;
        
        [grammarFileTextField setStringValue:varFileString];
        [checkGrammarStepButton setState:1];
        
    }
    [self checkSynthesisSteps];
    
}


/**
 
 TableView DataSoruce methods !!
 
 **/

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (int) [mFilesListArray count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(int)row
{
    return (NSString *) [mFilesListArray objectAtIndex:row];
}


@end