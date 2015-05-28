//
//  ATTextResult.h
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATTextResult : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *string;

- (instancetype)initWithRange:(NSRange)range string:(NSString *)string;

@end
