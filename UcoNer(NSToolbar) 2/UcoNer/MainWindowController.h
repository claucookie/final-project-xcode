//
//  MainWindowController.h
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 18/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MainWindowController : NSWindowController{
    
@private
    IBOutlet NSView *recognition;
    IBOutlet NSView *evaluation;
    IBOutlet NSView *finder;
    IBOutlet NSView *synthesis;
    int currentViewTag;
    
}

@property (assign) IBOutlet NSPopover *popover;

- (IBAction)showPopupInfo:(id)sender;

- (IBAction)switchView:(id)sender;



@end
