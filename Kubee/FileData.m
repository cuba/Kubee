//
//  FileData.m
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import "FileData.h"
@interface FileData()
@property (nonatomic, readonly) NSMutableDictionary *fileData;
@end

@implementation FileData

@synthesize fileData = _fileData;

- (id) initWithFullPath:(NSString *)filePath{
    self = [super init];
    if (self) {
        _fileData = [[NSMutableDictionary alloc] init];
        [_fileData setObject:[filePath lastPathComponent] forKey:@"filename"];
        [_fileData setObject:@"" forKey:@"preview"];
        [_fileData setObject:filePath forKey:@"fullpath"];
    }
    return self;
}

- (NSString *) fileName{
    return [self.fileData objectForKey:@"filename"];
}

- (NSString *) fullPath{
    return [self.fileData objectForKey:@"fullpath"];
}
- (NSString *) path{
    return [[self.fileData objectForKey:@"fullpath"] stringByDeletingLastPathComponent];
}
- (NSString *) preview{
    return [self.fileData objectForKey:@"preview"];
}

- (void) setFileWithPath:(NSString *)filePath{
    if (self.fileData) {
        [self.fileData release];
    }
    _fileData = [[NSMutableDictionary alloc] init];
    NSString *filename = [filePath lastPathComponent];
    
    [[self.fileData objectForKey:[NSString stringWithFormat:@"filename"]] addObject:filename];
    [[self.fileData objectForKey:[NSString stringWithFormat:@"preview"]] addObject:[NSString stringWithFormat:@""]];
    [[self.fileData objectForKey:[NSString stringWithFormat:@"fullpath"]] addObject:filePath];
}


- (void) setPreviewWithString:(NSString *)string{
    [self.fileData setObject:string forKey:@"preview"];
}

- (void) setFileNameWithString:(NSString *)string{
    [self.fileData setObject:string forKey:@"filename"];
}

- (BOOL) isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return [((FileData *)object).fileData isEqualToDictionary:self.fileData];
    }
    else return NO;
}

- (void)dealloc
{
    [self.fileData release];
    [super dealloc];
}

@end
