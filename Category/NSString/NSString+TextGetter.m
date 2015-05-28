//
//  NSString+TextGetter.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "NSString+TextGetter.h"
#import "ATTextResult.h"

@implementation NSString (TextGetter)


- (ATTextResult *)at_textResultOfCurrentLineCurrentLocation:(NSInteger)location
{
    NSInteger curseLocation = location;
    NSRange range = NSMakeRange(0, curseLocation);
    NSRange thisLineRange = [self rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];
    
    NSString *line = nil;
    if (thisLineRange.location != NSNotFound) {
        NSRange lineRange = NSMakeRange(thisLineRange.location + 1, curseLocation - thisLineRange.location - 1);
        if (lineRange.location < [self length] && NSMaxRange(lineRange) < [self length]) {
            line = [self substringWithRange:lineRange];
            return [[ATTextResult alloc] initWithRange:lineRange string:line];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (BOOL)isTriggerString:(NSString *)string {
    if ([self isEqualToString:string]) {
        return YES;
    }
    if (self.length == 3) {
        NSString *prefix = [self substringToIndex:1];
        NSString *suffix = [self substringFromIndex:2];
        NSString *concatString = [NSString stringWithFormat:@"%@%@", prefix, suffix];
        if ([concatString isEqualToString:string]) {
            return YES;
        }
    }
    return NO;

}

@end
