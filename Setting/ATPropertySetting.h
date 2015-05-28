//
//  ATPropertySetting.h
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kATPStrongTriggerString;
extern NSString *const kATPAssignTriggerString;
extern NSString *const kATPWeakTriggerString;
extern NSString *const kATPCopyTriggerString;

@interface ATPropertySetting : NSObject

@property (nonatomic, assign) BOOL useNonatomic;

@end
