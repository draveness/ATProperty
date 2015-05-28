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
NSString *const kATPAtomicityPrefix = @"com.draveness.ATProperty.atomicityPrefix";

@implementation ATPropertySetting

+ (ATPropertySetting *)defaultSetting {
    static dispatch_once_t once;
    static ATPropertySetting *defaultSetting;
    dispatch_once(&once, ^ {
        defaultSetting = [[ATPropertySetting alloc] init];

        NSDictionary *defaults = @{kATPAtomicityPrefix: @YES,
                                   kATPUseNonatomic: @YES};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return defaultSetting;
}

- (BOOL)useNonatomic {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kATPUseNonatomic];
}

- (void)setUseNonatomic:(BOOL)useNonatomic {
    [[NSUserDefaults standardUserDefaults] setBool:useNonatomic forKey:kATPUseNonatomic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)atomicityPrefix {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kATPAtomicityPrefix];
}

- (void)setAtomicityPrefix:(BOOL)atomicityPrefix {
    [[NSUserDefaults standardUserDefaults] setBool:atomicityPrefix forKey:kATPAtomicityPrefix];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
