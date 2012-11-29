//
//  KubeeAppDelegate.h
//  Kubee
//
//  Created by Jacob Sikorski on 2012-11-28.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileList.h"

@interface KubeeAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTableView *fileTableView;

// Toolbar Items
@property (assign) IBOutlet NSToolbarItem *addToolbarItem;
@property (assign) IBOutlet NSToolbarItem *removeToolbarItem;
@property (assign) IBOutlet NSToolbarItem *removeAllToolbarItem;
@property (assign) IBOutlet NSToolbarItem *refreshToolbarItem;
@property (assign) IBOutlet NSToolbarItem *previewToolbarItem;
@property (assign) IBOutlet NSToolbarItem *renameToolbarItem;
@property (assign) IBOutlet NSComboBox *filterComboBox;
@property (assign) IBOutlet NSComboBox *renameToComboBox;
@property (assign) IBOutlet NSButton *keepOriginalCheckBox;

// Actions
- (IBAction)addAction:(id)sender;
- (IBAction)removeAction:(id)sender;
- (IBAction)removeAllAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
- (IBAction)previewAction:(id)sender;
- (IBAction)renameAction:(id)sender;

@end
