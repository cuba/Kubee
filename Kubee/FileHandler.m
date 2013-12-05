//
//  FileHandler.m
//  Kubee
//
//  Created by Jacob Sikorski on 12-11-19.
//  Copyright (c) 2012 Jacob Sikorski. All rights reserved.
//

#import "FileHandler.h"
NSString const *varIndicator = @":";

@interface FileHandler()
@property (nonatomic, retain, readonly) NSArray *parsedFilter;
@end

@implementation FileHandler

@synthesize parsedFilter = _parsedFilter;
@synthesize currentCount = _currentCount;
@synthesize stepSize = _stepSize;



- (void)dealloc
{
    [_parsedFilter release];
    [super dealloc];
}

- (BOOL) setFilter:(NSString *)filter
{
    BOOL valid = [self isFilterValid:filter];
    if(valid){
        //NSLog(@"Setting filter: %@", filter);
        _parsedFilter = [filter componentsSeparatedByString:@":"];
    }
    return valid;
}

//Checks to see if a given filter is valid
- (BOOL) isFilterValid:(NSString *) filter
{
    //NSLog(@"Validating filter: %@", filter);
    BOOL valid = YES;
    for(NSUInteger i = 0; i < filter.length; i++){
        //NSLog(@"char = %@",[filter substringWithRange:NSMakeRange(i, 1)]);
        if ([[filter substringWithRange:NSMakeRange(i, [varIndicator length])] isEqualToString:@":"]) {
            if (valid) {
                valid = NO;
            }
            else{
                valid = YES;
            }
        }
    }
    return valid;
}

//Checks to see if a given filter is valid
- (BOOL) isRenameToValid:(NSString *) renameTo
{
    BOOL valid = YES;
    valid = [self isFilterValid:renameTo];
    
    if ([renameTo isEqualToString:@""]) {
        valid = NO;
    }
    
    return valid;
}

//Extracts the information using a parsedFilter array from original string and creates a new string with a string model
- (NSString *) renameString:(NSString *)string toNewString:(NSString *)newString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    NSMutableString *result = [NSMutableString stringWithString:newString];
    
    //REPLACE NUMBERS
    NSMutableArray *numbers = [[[NSMutableArray alloc] init] autorelease];
    
    NSUInteger loc = 0;
    NSUInteger len = 0;
    for (NSUInteger i = 0; i < result.length; i++) {
        if ([result characterAtIndex:i] == '#') {
            loc = i;
            while (i < result.length && [result characterAtIndex:i] == '#') {
                i++;
            }
            len = i - loc;
            //NSLog(@"Number: %@", [resultMutable substringWithRange:NSMakeRange(loc, len)]);
            [numbers addObject:[result substringWithRange:NSMakeRange(loc, len)]];
        }
    }
    
    NSString *currentNumberString = [NSString stringWithFormat:@"%lu", self.currentCount];
    for (NSUInteger i = 0; i < numbers.count; i++) {
        NSMutableString *numberString = [NSMutableString stringWithString:currentNumberString];
        NSMutableString *zerosString = [NSMutableString stringWithFormat:@""];
        while (numberString.length + zerosString.length < [[numbers objectAtIndex:i] length]) {
            [zerosString appendString:@"0"];
        }
        NSString *resultNumberString = [NSString stringWithFormat:@"%@%@",zerosString, numberString];
        NSString *variableName = [NSString stringWithFormat:@":%@:", [numbers objectAtIndex:i]];
        [result replaceOccurrencesOfString: variableName withString:resultNumberString options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    }
    
    //RENAME VARIABLES
    //NSLog(@"String: %@", string);
    BOOL tagsBalanced = YES;
    for (NSUInteger i = 2; i < [self.parsedFilter count] && tagsBalanced; i+=2) {
        NSString *stringBefore = [self.parsedFilter objectAtIndex:i-2];
        //NSLog(@"String Before: %@", stringBefore);
        NSString *stringAfter = [self.parsedFilter objectAtIndex:i];
        NSString *variable = [self.parsedFilter objectAtIndex:i-1];
        NSRange rangeBefore, rangeAfter, rangeCenter;
        NSString *extractedVariable;
        
        if (stringBefore.length < mutableString.length && 
            [[mutableString substringToIndex:stringBefore.length] isEqualToString:stringBefore]
            ) {
            
            if (stringBefore.length == 0) {
                ;
            }
            else {
                rangeBefore = NSMakeRange(0, stringBefore.length);
                [mutableString deleteCharactersInRange:rangeBefore];
            }
            
            if (stringAfter.length == 0){
                rangeAfter = NSMakeRange(mutableString.length, 0);
            }
            else{
                rangeAfter = [mutableString rangeOfString:[self.parsedFilter objectAtIndex:i]];
            }
            
            rangeCenter = NSMakeRange(0, rangeAfter.location);
            
            if (rangeAfter.location == NSNotFound) {
                tagsBalanced = NO;
            }
            else {
                extractedVariable = [mutableString substringWithRange:rangeCenter];
                [mutableString deleteCharactersInRange:rangeCenter];
                //NSLog(@"Extracted Variable: %@", extractedVariable);
                
                NSString *variableName = [NSString stringWithFormat:@":%@:",variable];
                
                [result replaceOccurrencesOfString:variableName withString:extractedVariable options:NSLiteralSearch range:NSMakeRange(0, [result length])];
            }
        }
        else tagsBalanced = NO;
    }
    
    self.currentCount += self.stepSize;
    
    if (tagsBalanced) return [[[NSString alloc] initWithString:result] autorelease];
    else return string;
}
@end
