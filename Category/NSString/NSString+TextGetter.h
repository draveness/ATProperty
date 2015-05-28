//
//  NSString+TextGetter.h
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATTextResult;

@interface NSString (TextGetter)

- (ATTextResult *)at_textResultOfCurrentLineCurrentLocation:(NSInteger)location;

- (BOOL)isTriggerString:(NSString *)string;

@end
