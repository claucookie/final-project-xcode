//
//  FinderViewController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 29/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "FinderViewController.h"

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
    
    if(mFinderSteps >= 3){
        [startSearchButton setEnabled:YES];
        [startSearchLabel setHidden:NO];
    }
    NSLog(@"%ld", mFinderSteps);
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
            mFinderSteps++;
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
        
   
        // We clean the selected file textfield
        [selectedFileTextField setStringValue:@""];
        [filesListTableView reloadData];
        // We activate the tableview
        [filesListTableView setEnabled:YES];
        
        // Step done
        [checkCorpusStepButton setState:1];
        [self checkFinderSteps];
        
    }
}

- (IBAction)fileSelected:(id)sender {
    
    // Showing name file into file textfield.
    NSInteger row = [sender selectedRow];
    NSString *selectedFileName = [mFilesListArray objectAtIndex:row];
    
    [selectedFileTextField setStringValue:selectedFileName];
    
    // Getting file data
    NSMutableString *fullPathFile = [[NSMutableString alloc] init];
    [fullPathFile appendString:[mCorpusURL absoluteString]];
    [fullPathFile appendString:selectedFileName];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPathFile]];
    // if data is in another encoding, for example ISO-8859-1
    NSString *fileContent = [[NSString alloc]
                             initWithData:data encoding: NSISOLatin1StringEncoding];
    
    NSLog(@"%@", fileContent);
    
    // Step done
    [checkFileStepButton setState:1];
    [self checkFinderSteps];
}

- (IBAction)regularExpressionWritten:(id)sender{
    
    if ([[regularExpressionTextField stringValue] isNotEqualTo:@""]) {
        
        // Step done
        [checkRegExpStepButton setState:1];
        
        if (!mRegularExpresionWasWrittenYet) {
            mFinderSteps++;
            mRegularExpresionWasWrittenYet = YES;
        }
        
    }
    else if (mFinderSteps > 0 && [checkRegExpStepButton state] == 1){
        mFinderSteps--;
        [checkRegExpStepButton setState:0];
        mRegularExpresionWasWrittenYet = NO;
    }
    [self checkFinderSteps];
    
}

- (IBAction)selectCorpusOrFileClick:(id)sender{
    
    Boolean isOK = YES;
    
    // If corpus is clicked
    if([sender tag] == 1 && [[corpusFolderTextField stringValue] isNotEqualTo:@""]){
        [fileToggleButton setState:0];
        [fileToggleButton setEnabled:YES];
        [corpusToggleButton setEnabled:NO];
        [corpusToggleButton setState:1];
    }
    // else if file button is clicked and a file was selected from list
    else if( [sender tag] == 2 && [[selectedFileTextField stringValue] isNotEqualTo:@""]){
        [corpusToggleButton setState:0];
        [corpusToggleButton setEnabled:YES];
        [fileToggleButton setEnabled:NO];
        [fileToggleButton setState:1];
    }
    else{
        [sender setState:0];
        [sender setEnabled:YES];
        isOK = NO;
    }
    
    if (isOK) {
        
        if (!mCorpusOrFileToggleButtonWasClickedYet) {
            mFinderSteps++;
            mCorpusOrFileToggleButtonWasClickedYet = YES;
        }
        
        // Step done
        [checkCorpusOrFileStepButton setState:1];
    }
    [self checkFinderSteps];
}


- (IBAction)startFinderTask:(id)sender {
    
    // TODO: Check if corpus txt folder and file folder are checked.
    // Show a popup to let the user choose between corpus and folder
    // recognition.
    
    // Call system program with
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
