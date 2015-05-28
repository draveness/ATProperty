//
//  ATTextResult.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "ATTextResult.h"

@implementation ATTextResult

- (instancetype)initWithRange:(NSRange)range string:(NSString *)string {
    if (self = [super init]) {
        _range = range;
        _string = string;
    }
    return self;
}

@end
