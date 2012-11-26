//
//  EvaluationViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 31/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "EvaluationViewController.h"
#import "PreferencesViewController.h"

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
    
    mEvaluationSteps = 0;
    
    // Customizing title label
    [evaluationTitleLabel setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"background_label"]]];
}

- (void)checkEvaluationSteps
{
    
    if(mEvaluationSteps == 3){
        [startEvaluationButton setEnabled:YES];
        [startEvaluationLabel setHidden:NO];
    }
    //NSLog(@"%ld", mEvaluationSteps);
}

- (NSString *)readFile:(NSString*) filepath
{
    NSString *filecontent;
    //Get file into string
    filecontent = [NSString stringWithContentsOfFile:filepath encoding: NSUTF8StringEncoding error:NULL];
    
    return filecontent; //Returns the first line captured to Run Log
}

- (Boolean)resultIsOk:(NSString*)result
{
    // Look for success message and return true or false
    NSRange aRange = [result rangeOfString:@"ChunkParse score"];

    if (aRange.location ==NSNotFound) {

        //NSLog(@"string not found");
        return NO;

    } else {

        //NSLog(@"string was found");
        return YES;

    }
    
}


/**
 
 Actions
 
 **/

- (IBAction)startEvaluationTask:(id)sender
{
    // Clear log panel, remove open button
    [evaluationResultTextView setString:@" "];
    [openResultButton setHidden:YES];
    // Clear output file
    [@"" writeToFile:mOutputFilePathString
           atomically:YES
             encoding:NSISOLatin1StringEncoding error:NULL];

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

    NSString *result;
    NSFileHandle *file;
    file = [pipe fileHandleForReading];



    @try {
        [task launch];

        NSData *data;
        data = [file readDataToEndOfFile];
        result = [self readFile:outputFileArgument];
        //NSLog (@"task returned:\n%@", result);
        
	}
	@catch (id theException) {
        [evaluationResultTextView setString:theException];
        NSLog(@"%@", theException);
	}
	@finally {
        [progressIndicator stopAnimation:self];
        [progressIndicator setHidden:YES];
        [startEvaluationButton setHidden:NO];

        [evaluationResultTextView setString:result];
        [logLabel setStringValue:@"  Evaluation task Result: "];

        if( [self resultIsOk:result] ){

            [openResultButton setHidden:NO];
        }

        //NSLog(@"This always happens.");
	}
}


- (IBAction)openResultFile:(id)sender
{
    // Get the favorite app
    NSString *favoriteApp = [PreferencesViewController getStringForKey:TEXT_APP_PREFERENCE];

    // Open result file with preferences app.
    // If is not specified, use default one.
    if ( ![favoriteApp isEqualToString:@""] ) {
        [[NSWorkspace sharedWorkspace] openFile:mOutputFilePathString
                                withApplication:favoriteApp];
    } else {
        [[NSWorkspace sharedWorkspace] openFile:mOutputFilePathString];
    }

    
}


- (IBAction)openSelectFolderPanel:(id)sender
{
    
    // Creating the open panel
    mSelectFolderOpenPanel = [NSOpenPanel openPanel];
    [mSelectFolderOpenPanel setCanChooseDirectories:YES];
    [mSelectFolderOpenPanel setCanChooseFiles:NO];
    [mSelectFolderOpenPanel setCanCreateDirectories:YES];
    [mSelectFolderOpenPanel setTitle:@"Select IOB Revised Corpus Folder: "];
    
    // Customizing path will be open
    NSString *favoritePath = [PreferencesViewController getStringForKey:IOB_REVISED_CORPUS_PREFERENCE];
    [mSelectFolderOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    
    // Showing the panel
    NSInteger resultNSInteger = [mSelectFolderOpenPanel runModal];
    
    NSURL *resultDirectory = nil;
    Boolean isCorpusFolderSelected = NO;
    NSString *varCorpusDir = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        //NSLog(@"doOpen we have an OK button");
        
        // Gettin url folder
        resultDirectory = [mSelectFolderOpenPanel directoryURL];
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];
        
        // Replacing white spaces
        varCorpusDir = [Util removeBadWhiteSpaces:varCorpusDir];
        varCorpusDir = [Util fixAccentInPathString:varCorpusDir];
        mCorpusPathString = [Util replaceWhiteSpacesByScapeChar:varCorpusDir];
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[corpusFolderTextField stringValue] isEqualToString:@""] ){
            // Step done
            mEvaluationSteps++;
        }
        
        [corpusFolderTextField setStringValue: varCorpusDir];
        isCorpusFolderSelected = YES;
        
    }
    // Click on Cancel button
    else if(resultNSInteger == NSCancelButton){
        
        //NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {
        
        //NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",resultNSInteger);
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
    mSelectFileOpenPanel = [NSOpenPanel openPanel];
    [mSelectFileOpenPanel setCanChooseDirectories:NO];
    [mSelectFileOpenPanel setCanChooseFiles:YES];
    [mSelectFileOpenPanel setCanCreateDirectories:YES];
    
    if( [sender tag] == GRAMMAR_RULES_FILE_TAG ){
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"gr"]];
        [mSelectFileOpenPanel setTitle:@"Select Entities Rules file: (*.gr) "];
        
        // Customizing path will be open
        NSString *favoritePath = [PreferencesViewController
                                  getStringForKey:GRAMMAR_FILE_PREFERENCE];
        [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    }
    else if( [sender tag] == TEXT_FILE_TAG ){
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
        [mSelectFileOpenPanel setTitle:@"Select Text file: (*.txt) "];
        [mSelectFileOpenPanel setAccessoryView:openPanelExtraButtonsView];
        
        // Customizing path will be open
        NSString *favoritePath = [PreferencesViewController
                                  getStringForKey:TEXT_FILE_PREFERENCE];
        [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    }
    
    // Showing the panel
    NSInteger resultNSInteger = [mSelectFileOpenPanel runModal];
    
    NSURL *resultFile = nil;
    Boolean isFileSelected = NO;
    NSString *varFileString = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        //NSLog(@"doOpen we have an OK button");
        
        
        // Gettin url file
        resultFile = [mSelectFileOpenPanel URL];
        
        // URL to string, cutting "file:/localhos..."
        varFileString = [[resultFile absoluteString] substringFromIndex:16];
        
        // Replacing white spaces
        varFileString = [Util removeBadWhiteSpaces:varFileString];
        varFileString = [Util fixAccentInPathString:varFileString];

        
        //NSLog(@"%@", varFileString);
        
        isFileSelected = YES;
        
    }
    // Click on Cancel button
    else if(resultNSInteger == NSCancelButton){
        
        //NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {
        
        //NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",resultNSInteger);
        return;
    }
    
    
    if( isFileSelected ){
        
        switch ([sender tag]) {
            case GRAMMAR_RULES_FILE_TAG:
                if( isFileSelected ){
                    
                    // Check if it's the first time the field is used
                    if( [[grammarFileTextField stringValue] length] == 0 )
                        mEvaluationSteps++;
                    
                    mGrammarPathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
                    [grammarFileTextField setStringValue: varFileString];
                    [checkGrammarStepButton setState:1];
                }
                break;
                
            case TEXT_FILE_TAG:
                if( isFileSelected ){
                    // Check if it's the first time the field is used
                    if( [[outputFileTextField stringValue] length] == 0 )
                        mEvaluationSteps++;
                    
                    mOutputFilePathString =  [Util replaceWhiteSpacesByScapeChar:varFileString];
                    [outputFileTextField setStringValue: varFileString];
                    [checkOutputFileStepButton setState:1];
                }
                break;
                
            default:
                break;
        }
        
    }
    
    [self checkEvaluationSteps];
    
}


- (IBAction)clearConsoleWhenClickOn:(id) sender
{
    [evaluationResultTextView setString:@" "];
}

- (IBAction)createNewTxtFile:(id)sender
{
    // Point to Document directory
    NSString *folderPath = [[[mSelectFileOpenPanel directoryURL] absoluteString] substringFromIndex:16];

    NSString *filePath = [folderPath
                          stringByAppendingPathComponent: [newFilenameTextField stringValue]];
    //NSLog(@"%@", filePath);
    filePath = [Util removeBadWhiteSpaces:filePath];
    filePath = [Util replaceWhiteSpacesByScapeChar:filePath];
    //NSLog(@"%@", filePath);

    // Create the file
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    [fileMgr createFileAtPath:filePath contents:nil attributes:nil];
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
