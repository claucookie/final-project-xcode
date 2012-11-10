//
//  RecognitionViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 30/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "RecognitionViewController.h"
#include <unistd.h>

@implementation RecognitionViewController

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib
{
    
    // Initalize fileListTableView
    [recogFilesListTableView setDataSource:self];
    
    mRecogSteps = 0;
    mCorpusOrFileToggleButtonWasClickedYet = NO;
    
    // Customizing title label
    [recognitionTitleLabel setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"background_label"]]];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}


- (void)checkRecogSteps
{
    
    if( mRecogSteps >= 4){
        [startRecognitionButton setEnabled:YES];
        [startRecognitionLabel setHidden:NO];
    }
    
    //NSLog(@"%ld", mRecogSteps);
}

- (Boolean)resultIsOk:(NSString*)result
{
    // Look for success message and return true or false
    NSRange aRange = [result rangeOfString:@"The list of entities in"];

    if (aRange.location ==NSNotFound) {
        
        //NSLog(@"string not found");
        return NO;
        
    } else {
        
        //NSLog(@"string was found");
        return YES;

    }
    
}



/**
 
 ACTIONS
 
 **/

- (IBAction)startRecognitionTask:(id)sender
{
    // Clear log panel and hide open button
    [recognitionResultTextField setString:@" "];
    [openResultButton setHidden:YES];
    // Clear output file
    [@"" writeToFile:mOutputFilePathString
          atomically:YES
            encoding:NSISOLatin1StringEncoding error:NULL];


    [startRecognitionButton setHidden:YES];
    
    // Setting and showing progress indicator
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator setHidden:NO];
    [progressIndicator display];

    
    // Call system program with
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Applications/uconerApp/uconerTasks/recognitionTask.app/Contents/MacOS/recognitionTask"];
    
    
    NSString *tagFileArgument = mTaggerPathString ;
    NSString *entFileArgument = mGrammarPathString;
    NSString *inCorpusArgument = mCorpusPathString;
    NSString *outputEntitiesFileArgument = mOutputFilePathString;
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"iob", @"--inCorpus", inCorpusArgument, @"--entFile", entFileArgument, @"--tagFile", tagFileArgument , @"--entListFile", outputEntitiesFileArgument, nil];
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
        [recognitionResultTextField setString:theException];
        NSLog(@"%@", theException);
	}
	@finally {
        [progressIndicator stopAnimation:self];
        [progressIndicator setHidden:YES];
        [startRecognitionButton setHidden:NO];

        [recognitionResultTextField setString:result];
        [logLabel setStringValue:@"  Recognition task Result: "];

        if( [self resultIsOk:result] ){

            [openResultButton setHidden:NO];
        }

        //NSLog(@"This always happens.");
	}
    
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

- (IBAction)openSelectFolderPanel:(id)sender
{
    
    // Creating the open panel
    mSelectFolderOpenPanel = [NSOpenPanel openPanel];
    [mSelectFolderOpenPanel setCanChooseDirectories:YES];
    [mSelectFolderOpenPanel setCanChooseFiles:NO];
    [mSelectFolderOpenPanel setCanCreateDirectories:YES];
    [mSelectFolderOpenPanel setTitle:@"Select Text Corpus folder: "];
    
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
        
        NSLog(@"doOpen we have an OK button");
        
        // Gettin url folder
        resultDirectory = [mSelectFolderOpenPanel directoryURL];
        mCorpusFolderURL = resultDirectory;
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];

        // Replacing white spaces
        varCorpusDir = [Util removeBadWhiteSpaces:varCorpusDir];
        varCorpusDir = [Util fixAccentInPathString:varCorpusDir];
        mCorpusPathString = [Util replaceWhiteSpacesByScapeChar:varCorpusDir];
        // We add +1 to recognition steps if is the first time to use the field
        if( [[recogInCorpusDirTextField stringValue] length] == 0){
            mRecogSteps++;
        }
        
        mCorpusPathString = varCorpusDir;
        // Showing path inside UI textfield
        [recogInCorpusDirTextField setStringValue: varCorpusDir];
        
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
        
        NSArray *filesArray = [[NSArray alloc] init];
        filesArray = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtPath:varCorpusDir error:nil];
        mFilesListArray = [[NSMutableArray alloc] init];
        [mFilesListArray addObjectsFromArray:filesArray];
        
        
        // We clean the selected file textfield
        [selectedFileTextField setStringValue:@""];
        [recogFilesListTableView reloadData];
        // We check the corpus step
        [recogCheckCorpus setState:1];
        // We activate the tableview
        [recogFilesListTableView setEnabled:YES];
        // We switch on the corpus toggle button
        [self selectCorpusOrFileClick:corpusToggleButton];
        
        //NSLog(@"%3ld", [sender tag]);
        
    }
}

- (IBAction)selectCorpusOrFileClick:(id)sender
{
    
    Boolean isOK = YES;
    
    // If corpus is clicked
    if([sender tag] == 1 && [[recogInCorpusDirTextField stringValue] isNotEqualTo:@""]){
        [fileToggleButton setState:0];
        [corpusToggleButton setEnabled:NO];
        [corpusToggleButton setState:1];
        [fileToggleButton setEnabled:YES];
    }
    // else if file button is clicked and a file was selected from list
    else if( [sender tag] == 2 && [[selectedFileTextField stringValue] isNotEqualTo:@""]){
        [corpusToggleButton setState:0];
        [fileToggleButton setEnabled:NO];
        [fileToggleButton setState:1];
        [corpusToggleButton setEnabled:YES];
    }
    else{
        [sender setState:0];
        [sender setEnabled:YES];
        isOK = NO;
    }
    
    [self checkRecogSteps];
}


- (IBAction)openSelectFilePanel:(id)sender
{
    
    // Creating the open panel

    mSelectFileOpenPanel = [NSOpenPanel openPanel];
    [mSelectFileOpenPanel setCanChooseDirectories:YES];
    [mSelectFileOpenPanel setCanChooseFiles:YES];
    [mSelectFileOpenPanel setCanCreateDirectories:YES];
    
    if( [sender tag] == GRAMMAR_RULES_FILE_TAG){
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"gr"]];
        [mSelectFileOpenPanel setTitle:@"Select Entities Rules file: (*.gr) "];
        
        // Customizing path will be open
        NSString *favoritePath = [PreferencesViewController getStringForKey:GRAMMAR_FILE_PREFERENCE];
        [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    }
    else if( [sender tag] == TAGGER_RULES_FILE_TAG ){
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"etq"]];
        [mSelectFileOpenPanel setTitle:@"Select Tag Rules file: (*.etq) "];
        
        // Customizing path will be open
        NSString *favoritePath = [PreferencesViewController getStringForKey:TAGGER_FILE_PREFERENCE];
        [mSelectFileOpenPanel setDirectoryURL:[NSURL fileURLWithPath:favoritePath]];
    }
    else if( [sender tag] == TEXT_FILE_TAG ){
        [mSelectFileOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
        //[mSelectFolderOpenPanel setAccessoryView:openPanelExtraButtonsView];
        [mSelectFileOpenPanel setTitle:@"Select Text Output file: (*.txt) "];
        //[mSelectFileOpenPanel setAccessoryView: openPanelExtraButtonsView];
        
        // Customizing path will be open
        NSString *favoritePath = [PreferencesViewController getStringForKey:TEXT_FILE_PREFERENCE];
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
        varFileString= [[resultFile absoluteString] substringFromIndex:16];
        // Replacing white spaces
        varFileString = [Util removeBadWhiteSpaces:varFileString];
        varFileString = [Util fixAccentInPathString:varFileString];
        
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
                if( [[recogGrammarFileTextField stringValue] length] == 0)                    mRecogSteps++;
                
                mGrammarPathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
                
                [recogGrammarFileTextField setStringValue: varFileString];
                [recogCheckGrammar setState:1];
                break;
                
            case TAGGER_RULES_FILE_TAG:
                if( [[recogTaggerFileTextField stringValue] length] == 0)                    mRecogSteps++;
                
                mTaggerPathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
                
                [recogTaggerFileTextField setStringValue: varFileString];
                [recogCheckTagger setState:1];
                break;
            
            case TEXT_FILE_TAG:
                if( [[entitiesListFileTextField stringValue] length] == 0)                    mRecogSteps++;
                
                mOutputFilePathString = [Util replaceWhiteSpacesByScapeChar:varFileString];
                
                [entitiesListFileTextField setStringValue: varFileString];
                [recogCheckOutputFile setState:1];
                break;
                
            default:
                break;
        }
        
    }
    
    [self checkRecogSteps];
    
}


- (IBAction)fileSelected:(id)sender
{
    
    // Showing name file into file textfield.
    NSInteger row = [sender selectedRow];
    NSString *selectedFileName = [mFilesListArray objectAtIndex:row];
    
    [selectedFileTextField setStringValue:selectedFileName];
    
    // Getting file data
    NSMutableString *fullPathFile = [[NSMutableString alloc] init];
    [fullPathFile appendString:[mCorpusFolderURL absoluteString]];
    [fullPathFile appendString:selectedFileName];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPathFile]];
    // if data is in another encoding, for example ISO-8859-1
    NSString *fileContent = [[NSString alloc]
                             initWithData:data encoding: NSISOLatin1StringEncoding];
    
    //NSLog(@"%@", fileContent);
    // Showing content
    [recognitionResultTextField setString:fileContent];
    [logLabel setStringValue:@"  File Content:"];
    [recogCheckFile setState:1];
    
    // We switch on the file toggle button
    [self selectCorpusOrFileClick:fileToggleButton];
    
    
}

- (IBAction)clearConsoleWhenClickOn:(id) sender
{
    [recognitionResultTextField setString:@" "];
}

- (IBAction)createNewTxtFile:(id)sender
{
    // Create file manager
    //NSFileManager *fileMgr = mFileManager;
    
    // Point to Document directory
    NSString *folderPath = [[[mSelectFileOpenPanel directoryURL] absoluteString] substringFromIndex:16];
    
    NSString *filePath = [folderPath
                          stringByAppendingPathComponent: [newFilenameTextField stringValue]];
    //NSLog(@"%@", filePath);
    
    // String to write
    NSString *str = @"";
    
    // Write the file
    [str writeToFile:filePath atomically:YES
            encoding:NSUTF8StringEncoding error:nil];
}



// ==========================================================
// table view data source methods
// ==========================================================
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
