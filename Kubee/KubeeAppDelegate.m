//
//  KubeeAppDelegate.m
//  Kubee
//
//  Created by Jacob Sikorski on 2012-11-28.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import "KubeeAppDelegate.h"

@interface KubeeAppDelegate()
@property (retain) FileList *fileList;

- (void) checkIfFileListIsEmptyAndDisableButtons;
@end

@implementation KubeeAppDelegate

@synthesize fileList                = _fileList;

@synthesize fileTableView           = _fileTableView;
@synthesize addToolbarItem          = _addToolbarItem;
@synthesize removeToolbarItem       = _removeToolbarItem;
@synthesize removeAllToolbarItem    = _removeAllToolbarItem;
@synthesize refreshToolbarItem      = _refreshToolbarItem;
@synthesize previewToolbarItem      = _previewToolbarItem;
@synthesize renameToolbarItem       = _renameToolbarItem;

@synthesize filterComboBox          = _filterComboBox;
@synthesize renameToComboBox        = _renameToComboBox;
@synthesize keepOriginalCheckBox    = _keepOriginalCheckBox;

- (void)dealloc
{
    [self.fileList release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.fileList = [[FileList alloc] init];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)addAction:(id)sender {
    int i; // Loop counter.
    
    // Create the File Open Dialog class.
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openPanel setCanChooseFiles:YES];
    
    // Diable the selection of directories in the dialog.
    [openPanel setCanChooseDirectories:NO];
    
    // Allow for multiple selection:
    [openPanel setAllowsMultipleSelection:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openPanel runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* filesSelected = [openPanel URLs];
        
        // Loop through all the files and process them.
        for( i = 0; i < [filesSelected count]; i++ )
        {
            NSURL *url = (NSURL *)[filesSelected objectAtIndex:i];
            NSString *path = [url path];
            [self.fileList addFileWithFilePath:path];
        }
    }
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)removeAction:(id)sender {
    [self.fileList removeFilesAtIndexes:[self.fileTableView selectedRowIndexes]];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)removeAllAction:(id)sender {
    [self.fileList release];
    self.fileList = [[FileList alloc] init];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)refreshAction:(id)sender {
    [self.fileList refreshList];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)previewAction:(id)sender {
    NSError *error = [[[NSError alloc] init] autorelease];
    [self.fileList previewFileListUsingFilter:self.filterComboBox.stringValue andString:self.renameToComboBox.stringValue error:&error];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}

- (IBAction)renameAction:(id)sender {
    NSError *error = [[[NSError alloc] init] autorelease];
    [self.fileList renameFileListUsingFilter:self.filterComboBox.stringValue andString:self.renameToComboBox.stringValue error:&error copy:(self.keepOriginalCheckBox.state == NSOnState)];
    [self.fileTableView reloadData];
    [self checkIfFileListIsEmptyAndDisableButtons];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.fileList count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"filename"]) {
        // We pass us as the owner so we can setup target/actions into this main controller object
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [self.fileList filenameAtIndex:row];
        return cellView;
    }
    else if ([identifier isEqualToString:@"preview"]) {
        // We pass us as the owner so we can setup target/actions into this main controller object
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [self.fileList previewAtIndex:row];
        return cellView;
    }
    else if ([identifier isEqualToString:@"directory"]) {
        // We pass us as the owner so we can setup target/actions into this main controller object
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [self.fileList pathAtIndex:row];
        return cellView;
    }
    else {
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

- (void) checkIfFileListIsEmptyAndDisableButtons{
    if([self.fileList count] > 0){
        [self.previewToolbarItem setEnabled:YES];
        [self.renameToolbarItem setEnabled:YES];
        [self.removeAllToolbarItem setEnabled:YES];
        [self.removeToolbarItem setEnabled:YES];
    }
    else{
        [self.previewToolbarItem setEnabled:NO];
        [self.renameToolbarItem setEnabled:NO];
        [self.removeAllToolbarItem setEnabled:NO];
        [self.removeToolbarItem setEnabled:NO];
    }
}
@end
