//
//  ATProperty.h
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface ATProperty : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end