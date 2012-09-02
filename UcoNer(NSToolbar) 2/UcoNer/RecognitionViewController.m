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

-(void)awakeFromNib{
    
    // Initalize fileListTableView
    [recogFilesListTableView setDataSource:self];
    mRecogSteps = 0;
    mCorpusOrFileToggleButtonWasClickedYet = NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}



- (void)checkRecogSteps {
    
    if( mRecogSteps >= 3){
        [startRecognitionButton setEnabled:YES];
        [startRecognitionLabel setHidden:NO];
    }
    
    NSLog(@"%ld", mRecogSteps);
}

/**
 
 ACTIONS
 
 **/

- (IBAction)startRecognitionTask:(id)sender
{
    
    
    // Call system program with
    NSTask *task;
    task = [[NSTask alloc] init];
    //[task setLaunchPath: @"/Users/claucookie/Documents/Desarrollo/MacOS/uconerTasks/recognitionTask.app/Contents/MacOS/recognitionTask"];
    [task setLaunchPath:@"/Applications/uconerApp/uconerTasks/recognitionTask.app/Contents/MacOS/recognitionTask"];
    
    //NSArray *arguments;
    //arguments = [NSArray arrayWithObjects: @"foo", @"bar.txt", nil];
    //[task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"task returned:\n%@", string);
    
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
        mCorpusFolderURL = resultDirectory;
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];
        
        NSLog(@"%@", varCorpusDir);
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[recogInCorpusDirTextField stringValue] length] == 0){
            mRecogSteps++;
        }
        
        [recogInCorpusDirTextField setStringValue:varCorpusDir];
        
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
        
        
        NSArray *filesArray = [[NSArray alloc] init];
        filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:varCorpusDir error:nil];
        
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
        
        NSLog(@"%3ld", [sender tag]);
        
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
    NSOpenPanel *tvarOp = [NSOpenPanel openPanel];
    [tvarOp setCanChooseDirectories:NO];
    [tvarOp setCanChooseFiles:YES];
    
    if( [sender tag] == 2 )
        [tvarOp setAllowedFileTypes:[NSArray arrayWithObject:@"etq"]];
    else if( [sender tag] == 1 )
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
        
        switch ([sender tag]) {
            case 1:
                if( [[recogGrammarFileTextField stringValue] length] == 0)                    mRecogSteps++;
                [recogGrammarFileTextField setStringValue:varFileString];
                [recogCheckGrammar setState:1];
                break;
                
            case 2:
                if( [[recogTaggerFileTextField stringValue] length] == 0)                    mRecogSteps++;
                [recogTaggerFileTextField setStringValue:varFileString];
                [recogCheckTagger setState:1];
                break;
                
            default:
                break;
        }
        
        
    }
    
    [self checkRecogSteps];
    
}


- (IBAction)recogFileSelected:(id)sender
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
    
    NSLog(@"%@", fileContent);
    [recogFileContentTextField setString:fileContent];
    [recogCheckFile setState:1];
    
    // We switch on the file toggle button
    [self selectCorpusOrFileClick:fileToggleButton];
    
    
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
