//
//  SynthesisViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 01/09/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "SynthesisViewController.h"
#import "PreferencesViewController.h"

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
    
    // Customizing title label
    [synthesisTitleLabel setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"background_label"]]];
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
    // Clear log panel
    [synthesisResultTextView setString:@" "];

    [startSynthesisButton setHidden:YES];
    
    // Setting and showing progress indicator
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator setHidden:NO];
    [progressIndicator display];
    
    
    // Call system program with
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Applications/uconerApp/uconerTasks/synthesisTask.app/Contents/MacOS/synthesisTask"];
    
    
    NSString *inCorpusArgument = mCorpusPathString;
    NSString *texFileArgument = mTexFilePathString;
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"--iobCorpus", inCorpusArgument, @"--outLatexFile", texFileArgument, nil];
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
    //result = [self readFile:texFileArgument];
    result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog (@"task returned:\n%@", result);
    
    [progressIndicator setHidden:YES];
    [synthesisResultTextView setString: result];
    NSLog(@"%@", result);
    [logLabel setStringValue:@" Synthesis task Result: "];
    [startSynthesisButton setHidden:NO];
}

- (IBAction)openSelectFolderPanel:(id)sender
{
    
    // Creating the open panel
    mSelectFolderOpenPanel = [NSOpenPanel openPanel];
    [mSelectFolderOpenPanel setCanChooseDirectories:YES];
    [mSelectFolderOpenPanel setCanChooseFiles:NO];
    [mSelectFolderOpenPanel setCanCreateDirectories:YES];
    [mSelectFolderOpenPanel setTitle:@"Select IOB Corpus folder: "];
    
    // Customizing path will be open
    NSString *favoritePath = [PreferencesViewController getStringForKey:IOB_CORPUS_PREFERENCE];
    [mSelectFolderOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    
    // Showing the panel
    NSInteger resultNSInteger = [mSelectFolderOpenPanel runModal];
    
    NSURL *resultDirectory = nil;
    Boolean isCorpusFolderSelected = NO;
    NSString *varCorpusDir = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        NSLog(@"doOpen we have an OK button");
        
        // Gettin url folder
        resultDirectory = [mSelectFolderOpenPanel directoryURL];
        mCorpusURL = resultDirectory;
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];

        // Replacing white spaces
        varCorpusDir = [Util removeBadWhiteSpaces:varCorpusDir];
        varCorpusDir = [Util fixAccentInPathString:varCorpusDir];
        mCorpusPathString = [Util replaceWhiteSpacesByScapeChar:varCorpusDir];
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[corpusFolderTextField stringValue] isEqualToString:@""] ){
            // Step done
            mSynthesisSteps++;
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
        [self checkSynthesisSteps];
        
    }
}

- (IBAction)openSelectFilePanel:(id)sender
{
    
    // Creating the open panel
    mSelectFileOpenPanel = [NSOpenPanel openPanel];
    [mSelectFileOpenPanel setCanChooseDirectories:YES];
    [mSelectFileOpenPanel setCanChooseFiles:YES];
    [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"tex"]];
    [mSelectFileOpenPanel setCanCreateDirectories:YES];
    [mSelectFileOpenPanel setTitle:@"Select Output Latex file: (*.tex) "];
    //[mSelectFileOpenPanel setAccessoryView:openPanelExtraButtonsView];
    
    // Customizing path will be open
    NSString *favoritePath = [PreferencesViewController getStringForKey:LATEX_FILE_PREFERENCE];
    [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    
    // Showing the panel
    
    NSInteger resultNSInteger = [mSelectFileOpenPanel runModal];
    
    
    NSURL *resultFile = nil;
    Boolean isFileSelected = NO;
    NSString *varFileString = nil;
    
    // Click on OK button
    if(resultNSInteger == NSOKButton){
        
        NSLog(@"doOpen we have an OK button");
        
        
        // Gettin url file
        resultFile = [mSelectFileOpenPanel URL];
        
        // URL to string, cutting "file:/localhos..."
        varFileString= [[resultFile absoluteString] substringFromIndex:16];
        
        // Replacing white spaces
        varFileString = [Util removeBadWhiteSpaces:varFileString];
        varFileString = [Util fixAccentInPathString:varFileString];
        mTexFilePathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
        
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
        
        // We short the string
        [grammarFileTextField setStringValue: varFileString];
        
        [checkGrammarStepButton setState:1];
        
    }
    [self checkSynthesisSteps];
    
}

- (IBAction)clearConsoleWhenClickOn:(id) sender
{
    [synthesisResultTextView setString:@" "];
}

- (IBAction)createNewTxtFile:(id)sender
{
    // Create file manager
    //NSFileManager *fileMgr = mFileManager;
    
    // Point to Document directory
    NSString *folderPath = [[[mSelectFileOpenPanel directoryURL] absoluteString] substringFromIndex:16];
    
    NSString *filePath = [folderPath
                          stringByAppendingPathComponent: [newFilenameTextField stringValue]];
    NSLog(@"%@", filePath);
    
    // String to write
    NSString *str = @"";
    
    // Write the file
    [str writeToFile:filePath atomically:YES
            encoding:NSUTF8StringEncoding error:nil];
}


/**
 
 TableView DataSoruce methods !!!
 
 **/

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (int) [mFilesListArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(int)row
{
    return (NSString *) [mFilesListArray objectAtIndex:row];
}


@end
