//
//  FileList.h
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileData.h"
#import "FileHandler.h"

@interface FileList: NSObject {
@private
    NSFileManager *fileManager;
}
@property (nonatomic, readonly) NSUInteger count;

- (FileData *) fileDataForIndex:(NSUInteger)index;

//- (NSArray *) arrayForKey:(id)key;

- (NSString *) stringForKey:(id)key andIndex:(NSUInteger)index;
- (NSString *) fullPathAtIndex:(NSUInteger) index;
- (NSString *) filenameAtIndex:(NSUInteger) index;
- (NSString *) pathAtIndex:(NSUInteger) index;
- (NSString *) previewAtIndex:(NSUInteger) index;

- (void) removeFilesAtIndexes:(NSIndexSet *)indexes;
- (void) addFileWithFilePath:(NSString *) filePath;
- (void) setPreview:(NSString *)preview AtIndex:(NSUInteger)index;
- (void) setFilename:(NSString *)filename AtIndex:(NSUInteger)index;

- (BOOL) previewFileListUsingFilter:(NSString *)filter andString:(NSString *)string error:(NSError **)error;
- (BOOL) renameFileListUsingFilter:(NSString *)filter andString:(NSString *)string error:(NSError **)error copy:(BOOL)copy ;

- (BOOL) renameFileAtIndex:(NSUInteger)index error:(NSError **)error;
- (BOOL) copyFileAtIndex:(NSUInteger)index error:(NSError **)error;

- (BOOL) checkFileAtIndex:(NSUInteger)index;
- (void) refreshFileAtIndex:(NSUInteger)index;
- (void) refreshList;

- (NSUInteger) count;



@end
