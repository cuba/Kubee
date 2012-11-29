//
//  FileHandler.h
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileList.h"

@interface FileHandler : NSObject {}

@property NSInteger currentCount;
@property NSInteger stepSize;

- (BOOL) setFilter:(NSString *)filter;
- (BOOL) isFilterValid:(NSString *) filter;
- (BOOL) isRenameToValid:(NSString *) renameTo;
- (NSString *) renameString:(NSString *)string toNewString:(NSString *)newString;

@end
