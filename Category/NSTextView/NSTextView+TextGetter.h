//
//  NSTextView+TextGetter.h
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATTextResult;

@interface NSTextView (TextGetter)

- (NSInteger)at_currentCurseLocation;

- (ATTextResult *)at_textResultOfCurrentLine;


@end
