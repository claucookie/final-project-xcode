//
//  EvaluationViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 31/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "EvaluationViewController.h"

@implementation EvaluationViewController

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)awakeFromNib
{
    // Initalize fileListTableView
    [filesListTableView setDataSource:self];
    
    // Steps counter = 0
    mEvaluationSteps = 0;
}

- (void)checkEvaluationSteps
{
    
    if(mEvaluationSteps == 2){
        [startEvaluationButton setEnabled:YES];
        [startEvaluationLabel setHidden:NO];
    }
    NSLog(@"%ld", mEvaluationSteps);
}

/**
 
 Actions
 
 **/

- (IBAction)openSelectFolderPanel:(id)sender {
    
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
            mEvaluationSteps++;
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
        [self checkEvaluationSteps];
        
    }
}

- (IBAction)openSelectFilePanel:(id)sender {
    
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
            mEvaluationSteps++;
            
        [grammarFileTextField setStringValue:varFileString];
        [checkGrammarStepButton setState:1];
        
    }
    [self checkEvaluationSteps];
    
}

- (IBAction)startEvaluationTask:(id)sender{
    
    // TODO:
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
