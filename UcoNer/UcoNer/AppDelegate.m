//
//  AppDelegate.m
//  UcoNer
//
//  Created by Claudia María Luque Fernández on 18/08/12.
//  Copyright (c) 2012 Claudia María Luque Fernández. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@implementation AppDelegate

- (void) awakeFromNib
{
    if (!mainWindowController) {
        mainWindowController = [[MainWindowController alloc] init];
    }
    
    [mainWindowController showWindow:nil];
}


@end
