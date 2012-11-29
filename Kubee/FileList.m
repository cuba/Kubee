//
//  FileList.m
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import "FileList.h"

@interface FileList()
@property (retain) NSMutableArray *files;
@property (retain) FileHandler *fileHandler;
@end
@implementation FileList

@synthesize files = _files;
@synthesize fileHandler = _fileHandler;

- (id)init
{
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
        _fileHandler = [[FileHandler alloc] init];
        _files = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_files release];
    [fileManager release];
    [FileHandler release];
    [super dealloc];
}

- (FileData *) fileDataForIndex:(NSUInteger)index{
    return [_files objectAtIndex:index];
}

- (NSString *) stringForKey:(id)key andIndex:(NSUInteger)index{
    return [[_files objectAtIndex:index] objectForKey:key];
}

- (NSString *) fullPathAtIndex:(NSUInteger) index{
    return [[self fileDataForIndex:index] fullPath];
}

- (NSString *) filenameAtIndex:(NSUInteger) index{
    return [[self fileDataForIndex:index] fileName];
}

- (NSString *) pathAtIndex:(NSUInteger) index{
    return [[self fileDataForIndex:index] path];
}

- (NSString *) previewAtIndex:(NSUInteger) index{
    return [[self fileDataForIndex:index] preview];
}

- (void) addFileWithFilePath:(NSString *) filePath
{
    FileData *fileData = [[[FileData alloc] initWithFullPath:filePath] autorelease];
    if (![_files containsObject:fileData]) {
        [_files addObject:fileData];
    }
}

- (void) setFileWithWithPath:(NSString *)path atIndex:(NSUInteger)index
{
    FileData *fileData = [[[FileData alloc] initWithFullPath:path] autorelease];
    if (![_files containsObject:fileData]) {
        [_files replaceObjectAtIndex:index withObject:fileData];
    }  
}

- (void) setPreview:(NSString *)preview AtIndex:(NSUInteger)index
{
    [[self fileDataForIndex:index] setPreviewWithString:preview];
}

- (void) setFilename:(NSString *)filename AtIndex:(NSUInteger)index
{
    [[self fileDataForIndex:index] setFileNameWithString:@""];
}

- (void) removeFilesAtIndexes:(NSIndexSet *)indexes
{
    [_files removeObjectsAtIndexes:indexes];
}

- (void) removeFileAtIndex:(NSUInteger)index
{
    [_files removeObjectAtIndex:index];
}

- (NSUInteger) count
{
    return [_files count];
}

- (BOOL) checkFileAtIndex:(NSUInteger)index
{
    return [fileManager fileExistsAtPath:[self fullPathAtIndex:index]];
}

- (void) refreshFileAtIndex:(NSUInteger)index
{
    if (![self checkFileAtIndex:index]) {
        [self removeFileAtIndex:index];
    }
}

- (void) refreshList
{
    for (NSUInteger i = 0; i < [self count]; i++) {
        [self refreshFileAtIndex:i];
    }
    
}

- (BOOL) previewFileListUsingFilter:(NSString *)filter andString:(NSString *)string error:(NSError **)error
{
    //NSLog(@"Previewing File List");
    //NSLog(@"Filter: %@", filter);
    //NSLog(@"String: %@", string);
    BOOL validFilter = [self.fileHandler setFilter:filter];
    if (validFilter)
    {
        self.fileHandler.stepSize = 1;
        self.fileHandler.currentCount = 1;
        
        if (self.count > 0 ) {
            
            for (NSUInteger i = 0; i < [self count]; i++) {
                //NSLog(@"Previewing File %@", [self filenameAtIndex:i]);
                // TODO: If the directory has changed, restart numbering
                NSString *result = [self.fileHandler renameString:[self filenameAtIndex:i] toNewString:string];
                
                [self setPreview:result AtIndex:i];
            }
        }
        
        return YES;
    }
    NSLog(@"Filter Failed");
    return NO;
}

- (BOOL) renameFileListUsingFilter:(NSString *)filter andString:(NSString *)string error:(NSError **)error copy:(BOOL)copy
{
    BOOL success = [self previewFileListUsingFilter:filter andString:string error:error];
    for (NSUInteger i = 0; i < [self count] && success; i++) {
        if(copy) success = [self copyFileAtIndex:i error:error];
        else success = [self renameFileAtIndex:i error:error];
    }
    return success;
}

// Need to call previewFileListUsingFilterAndString first
- (BOOL) renameFileAtIndex:(NSUInteger)index error:(NSError **)error
{
    NSString *newPath = [NSString stringWithString:[[self pathAtIndex:index] stringByAppendingPathComponent:[self previewAtIndex:index]]];
    
    if([fileManager moveItemAtPath:[self fullPathAtIndex:index] toPath:newPath error:error]){
        [self setFileWithWithPath:newPath atIndex:index];
        return YES;
    }
    return NO;
}


// Need to call previewFileListUsingFilterAndString first
- (BOOL) copyFileAtIndex:(NSUInteger)index error:(NSError **)error
{
    NSString *newPath = [NSString stringWithString:[[self pathAtIndex:index] stringByAppendingPathComponent:[self previewAtIndex:index]]];
    
    if([fileManager copyItemAtPath:[self fullPathAtIndex:index] toPath:newPath error:error]){
        [self setFileWithWithPath:newPath atIndex:index];
        return YES;
    }
    return NO;
}

@end
