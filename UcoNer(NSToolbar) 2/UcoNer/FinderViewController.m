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
    [corpusFolderTextField setStringValue:@"hola"];
    // Initalize fileListTableView
    [filesListTableView setDataSource:self];
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
        // TODO:
        
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
        
        
        NSArray *filesArray = [[NSArray alloc] init];
        filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:varCorpusDir error:nil];
        
        mFilesListArray = [[NSMutableArray alloc] init];
        [mFilesListArray addObjectsFromArray:filesArray];
        
   
        // We clean the selected file textfield
        [selectedFileTextField setStringValue:@""];
        [filesListTableView reloadData];
        // We activate the tableview
        [filesListTableView setEnabled:YES];
        
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
