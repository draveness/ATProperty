//
//  NSTextView+TextGetter.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "NSTextView+TextGetter.h"
#import "NSString+TextGetter.h"

@implementation NSTextView (TextGetter)

- (NSInteger)at_currentCurseLocation {
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

- (ATTextResult *)at_textResultOfCurrentLine {
    return [self.textStorage.string at_textResultOfCurrentLineCurrentLocation:[self at_currentCurseLocation]];
}

@end
