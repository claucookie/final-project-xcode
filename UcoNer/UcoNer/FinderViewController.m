//
//  FinderViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 29/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "FinderViewController.h"
#import "Util.h"

@implementation FinderViewController

- (void)awakeFromNib
{
    // Initalize fileListTableView
    [filesListTableView setDataSource:self];
    
    // Steps counter = 0
    mFinderSteps = 0;
    
    // Initialize flags
    mCorpusOrFileToggleButtonWasClickedYet = NO;
    mRegularExpresionWasWrittenYet = NO;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}


- (void)checkFinderSteps {
    
    if(mFinderSteps == 3){
        [self activateStartButton];
    }
    else{
        [self deactivateStartButton];
    }
    NSLog(@"%ld", mFinderSteps);
}

- (void)activateStartButton {
    
    [startSearchButton setEnabled:YES];
    [startSearchLabel setHidden:NO];
}

- (void)deactivateStartButton {
    
    [startSearchButton setEnabled:NO];
    [startSearchLabel setHidden:YES];
}


/**
 
 Actions
 
 **/


- (IBAction)startFinderTask:(id)sender
{
    
    // We hide the button
    [startSearchButton setHidden:YES];
    
    // Setting and showing progress indicator
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator setHidden:NO];
    [progressIndicator display];
    
    
    // Call system program with
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Applications/uconerApp/uconerTasks/finderTask.app/Contents/MacOS/finderTask"];
    
    NSString *regularExpressionArgument = mRegexpString ;
    NSString *inCorpusArgument = mInCorpusPathString;
    NSString *outputFileArgument = mOutputFilePathString;
     
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"--inCorpus", inCorpusArgument, @"--findPattern", regularExpressionArgument, @"--outFile", outputFileArgument , nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *result;
    result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"task returned:\n%@", result);
    
    
    [progressIndicator setHidden:YES];
    [startSearchButton setHidden:NO];
    
    [logPanelTextView setString:result];
    [logLabel setStringValue:@"  Finder task Result: "];
    
    [self deactivateStartButton];
     
}

- (IBAction)openSelectFilePanel:(id)sender
{
    // Creating the open panel
    NSOpenPanel *tvarOp2 = [NSOpenPanel openPanel];
    [tvarOp2 setCanChooseDirectories:NO];
    [tvarOp2 setCanChooseFiles:YES];
    [tvarOp2 setCanCreateDirectories:YES];
    
    if( [sender tag] == 1 ){
        
        [tvarOp2 setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
        
        // Showing the panel
        NSInteger resultNSInteger = [tvarOp2 runModal];
        
        NSURL *resultFile = nil;
        Boolean isFileSelected = NO;
        NSString *varFileString = nil;
        
        // Click on OK button
        if(resultNSInteger == NSOKButton){
            
            NSLog(@"doOpen we have an OK button");
            
            // Gettin url file
            resultFile = [tvarOp2 URL];
            
            // URL to string, cutting "file:/localhos..."
            varFileString = [[resultFile absoluteString] substringFromIndex:16];
            varFileString = [Util removeBadWhiteSpaces:varFileString];
            
            mOutputFilePathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
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
                mFinderSteps++;

            mOutputFilePathString = varFileString;
            // We short the string
            [outputFileTextField setStringValue: [@"..." stringByAppendingString: [varFileString substringFromIndex: varFileString.length -48]]];
            [checkFileStepButton setState:1];
            
        }
        [self checkFinderSteps];
        
    }
    
}

- (IBAction)openSelectFolderPanel:(id)sender
{
    
    // Creating the open panel
    NSOpenPanel *tvarOp = [NSOpenPanel openPanel];
    [tvarOp setCanChooseDirectories:YES];
    [tvarOp setCanChooseFiles:NO];
    [tvarOp setCanCreateDirectories:YES];
    
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
        
        // Replacing white spaces
        varCorpusDir = [Util removeBadWhiteSpaces:varCorpusDir];
        mInCorpusPathString = [Util replaceWhiteSpacesByScapeChar:varCorpusDir];
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[corpusFolderTextField stringValue] isEqualToString:@""] ){
            // Step done
            mFinderSteps++;
        }
        
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
        
        
        mInCorpusPathString = varCorpusDir;
        // We short the string
        [corpusFolderTextField setStringValue: [@"..." stringByAppendingString: [varCorpusDir substringFromIndex: varCorpusDir.length -60]]];
        
        // LOADING files list array into Table view
        NSArray *filesArray = [[NSArray alloc] init];
        filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:varCorpusDir error:nil];
        
        mFilesListArray = [[NSMutableArray alloc] init];
        [mFilesListArray addObjectsFromArray:filesArray];
        
        // Loading files
        [filesListTableView reloadData];
        
        // Step done
        [checkCorpusStepButton setState:1];
        [self checkFinderSteps];
        
    }
}

- (IBAction)regularExpressionWritten:(id)sender
{
    // Somethin was written
    if ([[regularExpressionTextField stringValue] isNotEqualTo:@""]) {
        
        // Step done
        [checkRegExpStepButton setState:1];
        
        if (!mRegularExpresionWasWrittenYet) {
            mFinderSteps++;
            mRegularExpresionWasWrittenYet = YES;
        }
        
        mRegexpString = [regularExpressionTextField stringValue];
        
    }
    else if (mFinderSteps > 0 && [checkRegExpStepButton state] == 1){
        mFinderSteps--;
        [checkRegExpStepButton setState:0];
        mRegularExpresionWasWrittenYet = NO;
    }
    
    [self checkFinderSteps];
    
}

- (IBAction)clearConsoleWhenClickOn:(id) sender
{
    [logPanelTextView setString:@" "];
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
