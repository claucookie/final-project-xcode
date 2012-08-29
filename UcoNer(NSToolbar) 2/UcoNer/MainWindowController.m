//
//  MainWindowController.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 18/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib{
    
    // Initalize fileListTableView
    [recogFilesListTableView setDataSource:self];
    
    [[self window] setContentSize:[recognition frame].size];
    [[[self window] contentView] addSubview:recognition];
    [[[self window] contentView] setWantsLayer:YES];
    
    recogSteps = 0;
}

- (NSRect)newFrameForNewContentView:(NSView *)view {
    
    NSWindow *window = [self window];
    NSRect newFrameRect = [window frameRectForContentRect:[view frame]];
    //NSRect oldFrameRect = [window frame];
    NSSize newSize = newFrameRect.size;
    //NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [window frame];
    frame.size = newSize;
    //frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

- (NSView *)viewForTag:(int)tag {
    
    NSView *view = nil;
    
    switch (tag) {
        case 0:
            view = recognition;
            break;
        
        case 1 :
            view = evaluation;
            break;
            
        case 2:
            view = finder;
            break;
            
        case 3: default:
            view = synthesis;
            break;
    }
    
    return view;
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)item {
    
    if ([item tag] == currentViewTag)
        return NO;
    
    else
        return YES;
}



- (IBAction)switchView:(id)sender {
    
    int tag = (int) [sender tag];
    NSView *view = [self viewForTag:tag];
    NSView *previousView = [self viewForTag:currentViewTag];
    currentViewTag = tag;
    
    //NSRect newFrame = [self newFrameForNewContentView:view];
    
    [NSAnimationContext beginGrouping];
    
    if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
        [[NSAnimationContext currentContext] setDuration:1.0];
    }
    
    [[[[self window] contentView] animator] replaceSubview:previousView with:view];
    //[[[self window] animator] setFrame:newFrame display:YES];
    
    [NSAnimationContext endGrouping];
    
}

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
        recogCorpusURL = resultDirectory;
        
        // URL to string, cutting "file:/localhos..."
        varCorpusDir= [[resultDirectory absoluteString] substringFromIndex:16];
        
        NSLog(@"%@", varCorpusDir);
        
        // We add +1 to recognition steps if is the first time to use the field
        if( [[recogInCorpusDirTextField stringValue] length] == 0){
            recogSteps++;
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
        
        recogFilesListMArray = [[NSMutableArray alloc] init];
        [recogFilesListMArray addObjectsFromArray:filesArray];
        
        
        // We clean the selected file textfield
        [recogFileSelectedTextField setStringValue:@""];
        [recogFilesListTableView reloadData];
        // We check the corpus step
        [recogCheckCorpus setState:1];
        // We activate the tableview
        [recogFilesListTableView setEnabled:YES];
        
                
        NSLog(@"%3ld", [sender tag]);
        
        
        
    }
}

/**
 
 Recognition View methods
 
 **/

- (void)checkRecogSteps {
    
    if( recogSteps >= 3){
        [recogStartRecognitionButton setEnabled:YES];
        [recogStartRecognitionLabel setHidden:NO];
    }
}
- (IBAction)startRecognitionTask:(id)sender {
    
    // TODO: Check if corpus txt folder and file folder are checked.
    // Show a popup to let the user choose between corpus and folder
    // recognition.
    
    // Call system program with
}




- (IBAction)openSelectFilePanel:(id)sender {
    
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
                if( [[recogGrammarFileTextField stringValue] length] == 0)                    recogSteps++;
                [recogGrammarFileTextField setStringValue:varFileString];
                [recogCheckGrammar setState:1];
                break;
            
            case 2:
                if( [[recogTaggerFileTextField stringValue] length] == 0)                    recogSteps++;
                [recogTaggerFileTextField setStringValue:varFileString];
                [recogCheckTagger setState:1];
                break;
                
            default:
                break;
        }
        
        
    }
    
    [self checkRecogSteps];
  
}


- (IBAction)recogFileSelected:(id)sender {
    
    // Showing name file into file textfield.
    NSInteger row = [sender selectedRow];
    NSString *selectedFileName = [recogFilesListMArray objectAtIndex:row];
    
    [recogFileSelectedTextField setStringValue:selectedFileName];
    
    // Getting file data
    NSMutableString *fullPathFile = [[NSMutableString alloc] init];
    [fullPathFile appendString:[recogCorpusURL absoluteString]];
    [fullPathFile appendString:selectedFileName];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPathFile]];
    // if data is in another encoding, for example ISO-8859-1
    NSString *fileContent = [[NSString alloc]
                             initWithData:data encoding: NSISOLatin1StringEncoding];
    
    NSLog(@"%@", fileContent);
    [recogFileContentTextField setString:fileContent];
    [recogCheckFile setState:1];

        
}

    
// ==========================================================
// table view data source methods
// ==========================================================
- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (int) [recogFilesListMArray count];
}
    
- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
row:(int)row
{
    return (NSString *) [recogFilesListMArray objectAtIndex:row];
}




    
    

@end
