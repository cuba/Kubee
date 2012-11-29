//
//  FileData.h
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileData : NSObject {
}

- (id) initWithFullPath:(NSString *)filePath;

- (NSString *) fileName;
- (NSString *) fullPath;
- (NSString *) path;
- (NSString *) preview;
- (void) setFileWithPath:(NSString *)filePath;
- (void) setPreviewWithString:(NSString *)string;
- (void) setFileNameWithString:(NSString *)string;

@end
