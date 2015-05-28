//
//  ATPropertySetting.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "ATPropertySetting.h"

NSString *const kATPStrongTriggerString = @"@s";
NSString *const kATPAssignTriggerString = @"@a";
NSString *const kATPWeakTriggerString   = @"@w";
NSString *const kATPCopyTriggerString   = @"@c";

NSString *const kATPUseNonatomic = @"com.draveness.ATProperty.useNonatomic";

@implementation ATPropertySetting

- (BOOL)useNonatomic {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kATPUseNonatomic];
}

- (void)setUseNonatomic:(BOOL)useNonatomic {
    [[NSUserDefaults standardUserDefaults] setBool:useNonatomic forKey:kATPUseNonatomic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
