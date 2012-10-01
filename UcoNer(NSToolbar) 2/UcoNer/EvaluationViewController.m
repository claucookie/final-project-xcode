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
    
    if(mEvaluationSteps == 3){
        [startEvaluationButton setEnabled:YES];
        [startEvaluationLabel setHidden:NO];
    }
    NSLog(@"%ld", mEvaluationSteps);
}

/**
 
 Actions
 
 **/

- (IBAction)startEvaluationTask:(id)sender
{
    [startEvaluationButton setHidden:YES];
    
    // Setting and showing progress indicator
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator setHidden:NO];
    [progressIndicator display];
    
    
    // Call system program with
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Applications/uconerApp/uconerTasks/evaluationTask.app/Contents/MacOS/evaluationTask"];
    
    
    NSString *entFileArgument = mGrammarPathString;
    NSString *inCorpusArgument = mCorpusPathString;
    NSString *outputFileArgument = mOutputFilePathString;
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"--iobCorpus", inCorpusArgument, @"--grammarFile", entFileArgument, @"--outFile", outputFileArgument, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    // TODO: TRY CATCH  
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *result;
    result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"task returned:\n%@", result);
    
    [progressIndicator setHidden:YES];
    // TODO: READ CONTENT FROM OUTPUT FILE, BECAUSE RESULT DATA IS GETTING NULL WITH NO SENSE.
    [evaluationResultTextView setString: @"result"];
    NSLog(@"%@", result);
    [logLabel setStringValue:@"  Evaluation task Result: "];
    [startEvaluationButton setHidden:NO];
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
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];
        
        mCorpusPathString = varCorpusDir;
        
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

- (IBAction)openSelectFilePanel:(id)sender
{
    // Creating the open panel
    NSOpenPanel *tvarOp = [NSOpenPanel openPanel];
    [tvarOp setCanChooseDirectories:NO];
    [tvarOp setCanChooseFiles:YES];
    
    // Grammar file
    if( [sender tag] == 1 ){
        
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
            
            mGrammarPathString = varFileString;
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
        
    // Output file
    }else if( [sender tag] == 2 ){
        
        [tvarOp setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
        
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
            
            mOutputFilePathString = varFileString;
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
            
            if( [[outputFileTextField stringValue] length] == 0 )
                mEvaluationSteps++;
            
            [outputFileTextField setStringValue:varFileString];
            [checkOutputFileStepButton setState:1];
            
        }
        [self checkEvaluationSteps];
        
    }
    
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
