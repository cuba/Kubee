//
//  FileRenamer.m
//  Kubee
//
//  Created by Jacob Sikorski on 12/5/2013.
//  Copyright (c) 2013 Jacob Sikorski. All rights reserved.
//

#import "FileRenamer.h"

@implementation FileRenamer

- (id)init
{
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [fileManager release];
    [super dealloc];
}

- (BOOL) checkFileAtPath:(NSString *)path
{
    return [fileManager fileExistsAtPath:path];
}

// Need to call previewFileListUsingFilterAndString first
- (BOOL) renameFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error
{
    return [fileManager moveItemAtPath:srcPath toPath:dstPath error:error];
}


// Need to call previewFileListUsingFilterAndString first
- (BOOL) copyFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error
{
    return [fileManager copyItemAtPath:srcPath toPath:dstPath error:error];
}

@end
