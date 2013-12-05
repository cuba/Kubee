//
//  FileRenamer.h
//  Kubee
//
//  Created by Jacob Sikorski on 12/5/2013.
//  Copyright (c) 2013 Jacob Sikorski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileRenamer : NSObject {
@private
NSFileManager *fileManager;
}

- (BOOL) renameFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
- (BOOL) copyFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
- (BOOL) checkFileAtPath:(NSString *)path;

@end
