//
//  FinderViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 29/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "FinderViewController.h"
#import "PreferencesViewController.h"

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

    // Customizing title label
    [finderTitleLabel setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"background_label"]]];
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
    //NSLog(@"%ld", mFinderSteps);
}

- (void)activateStartButton {

    [startSearchButton setEnabled:YES];
    [startSearchLabel setHidden:NO];
}

- (void)deactivateStartButton {

    [startSearchButton setEnabled:NO];
    [startSearchLabel setHidden:YES];
}

- (Boolean)resultIsOk:(NSString*)result
{
    // Look for success message and return true or false
    NSRange aRange = [result rangeOfString:@"matched paragraphs"];

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


- (IBAction)startFinderTask:(id)sender
{
    // Clear log panel
    [finderResultTextView setString:@" "];
    [openResultButton setHidden:YES];
    // Clear output file
    [@"" writeToFile:mOutputFilePathString
          atomically:YES
            encoding:NSISOLatin1StringEncoding error:NULL];

    // We hide the start button
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

    NSString *result;
    NSFileHandle *file;
    file = [pipe fileHandleForReading];


    @try {
        [task launch];

        NSData *data;
        data = [file readDataToEndOfFile];
        result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        //NSLog (@"task returned:\n%@", result);
	}
	@catch (id theException) {
        [finderResultTextView setString:theException];
        NSLog(@"%@", theException);
	}
	@finally {
        [progressIndicator stopAnimation:self];
        [progressIndicator setHidden:YES];
        [startSearchButton setHidden:NO];

        [finderResultTextView setString:result];
        [logLabel setStringValue:@"  Finder task Result: "];

        if( [self resultIsOk:result] ){

            [openResultButton setHidden:NO];
        }

        //NSLog(@"This always happens.");
	}

    [self deactivateStartButton];

}

- (IBAction)openResultFile:(id)sender
{
    // Get the favorite app
    NSString *favoriteApp = [PreferencesViewController
                             getStringForKey:TEXT_APP_PREFERENCE];

    // Open result file with preferences app.
    // If is not specified, use default one.
    if ( ![favoriteApp isEqualToString:@""] ) {
        [[NSWorkspace sharedWorkspace] openFile:mOutputFilePathString
                                withApplication:favoriteApp];
    } else {
        [[NSWorkspace sharedWorkspace] openFile:mOutputFilePathString];
    }

    
}


- (IBAction)openSelectFilePanel:(id)sender
{
    // Creating the open panel
    mSelectFileOpenPanel = [NSOpenPanel openPanel];
    [mSelectFileOpenPanel setCanChooseDirectories:NO];
    [mSelectFileOpenPanel setCanChooseFiles:YES];
    [mSelectFileOpenPanel setCanCreateDirectories:YES];
    [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    [mSelectFileOpenPanel setTitle:@"Select output Text file: (*.txt) "];
    [mSelectFileOpenPanel setAccessoryView:openPanelExtraButtonsView];

    // Customizing path will be open
    NSString *favoritePath = [PreferencesViewController getStringForKey:TEXT_FILE_PREFERENCE];
    [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];

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
        varFileString = [Util removeBadWhiteSpaces:varFileString];
        varFileString = [Util fixAccentInPathString:varFileString];

        mOutputFilePathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
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

        if( [[outputFileTextField stringValue] length] == 0 )
            mFinderSteps++;

        mOutputFilePathString = varFileString;
        // We short the string
        [outputFileTextField setStringValue: varFileString];
        [checkFileStepButton setState:1];

    }
    [self checkFinderSteps];



}

- (IBAction)openSelectFolderPanel:(id)sender
{

    // Creating the open panel
    mSelectFolderOpenPanel = [NSOpenPanel openPanel];
    [mSelectFolderOpenPanel setCanChooseDirectories:YES];
    [mSelectFolderOpenPanel setCanChooseFiles:NO];
    [mSelectFolderOpenPanel setCanCreateDirectories:YES];
    [mSelectFolderOpenPanel setTitle:@"Select text Corpus folder: "];

    // Customizing path will be open
    NSString *favoritePath = [PreferencesViewController getStringForKey:TEXT_CORPUS_PREFERENCE];
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
        mCorpusURL = resultDirectory;

        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];

        // Replacing white spaces
        varCorpusDir = [Util removeBadWhiteSpaces:varCorpusDir];
        varCorpusDir = [Util fixAccentInPathString:varCorpusDir];
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

        //NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {

        //NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",resultNSInteger);
        return;
    }

    if( isCorpusFolderSelected ){

        mInCorpusPathString = varCorpusDir;
        // We short the string
        [corpusFolderTextField setStringValue: varCorpusDir];

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
    [finderResultTextView setString:@" "];
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
