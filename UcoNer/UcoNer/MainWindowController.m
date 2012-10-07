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

@synthesize popover;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib
{
       
    [[self window] setContentSize:[recognition frame].size];
    [[[self window] contentView] addSubview:recognition];
    [[[self window] contentView] setWantsLayer:YES];

}

- (NSRect)newFrameForNewContentView:(NSView *)view
{
    
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


/**
 
 Actions
 
 **/

- (IBAction)showPopupInfo:(id)sender
{
    [[self popover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    NSLog(@"%@", @"Info clicked");
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
    

@end
