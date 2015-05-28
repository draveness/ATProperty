//
//  ATPStringGenerator.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "ATPStringGenerator.h"
#import "ATPropertySetting.h"
#import "NSString+TextGetter.h"

@implementation ATPStringGenerator

+ (BOOL)shouldTrigger:(NSString *)currentLineResult {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[kATPStrongTriggerString, kATPWeakTriggerString, kATPCopyTriggerString, kATPAssignTriggerString]];
    NSMutableArray *readWriteArray = [[NSMutableArray alloc] init];
    for (NSString *string in array) {
        NSString *readTriggerString = [NSString stringWithFormat:@"@r%@",[string substringFromIndex:1]];
        NSString *writeTriggerString = [NSString stringWithFormat:@"@x%@",[string substringFromIndex:1]];
        [readWriteArray addObject:readTriggerString];
        [readWriteArray addObject:writeTriggerString];
    }
    [array addObjectsFromArray:readWriteArray];
    for (NSString *string in array) {
        if ([currentLineResult isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)insertTextWithType:(NSString *)type {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:@"@property "];
    [ms appendString:[self modifiedSymbolTupleWithType:type]];
    return ms;
}

+ (NSString *)modifiedSymbolTupleWithType:(NSString *)type {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"("];
    if ([[ATPropertySetting defaultSetting] useNonatomic]) {
        [string appendString:@"nonatomic"];
    } else {
        [string appendString:@"atomic"];
    }

    if ([[ATPropertySetting defaultSetting] atomicityPrefix]) {
        if ([type isTriggerString:kATPStrongTriggerString]) {
            [string appendString:@", strong"];
        } else if ([type isTriggerString:kATPWeakTriggerString]) {
            [string appendString:@", weak"];
        } else if ([type isTriggerString:kATPCopyTriggerString]) {
            [string appendString:@", copy"];
        } else if ([type isTriggerString:kATPAssignTriggerString]) {
            [string appendString:@", assign"];
        }
    } else {
        if ([type isTriggerString:kATPStrongTriggerString]) {
            [string insertString:@"strong, " atIndex:1];
        } else if ([type isTriggerString:kATPWeakTriggerString]) {
            [string insertString:@"weak, " atIndex:1];
        } else if ([type isTriggerString:kATPCopyTriggerString]) {
            [string insertString:@"copy, " atIndex:1];
        } else if ([type isTriggerString:kATPAssignTriggerString]) {
            [string insertString:@"assign, " atIndex:1];
        }
    }

    if ([self isReadonly:type]) {
        [string appendString:@", readonly) "];
    } else if ([self isReadWrite:type]) {
        [string appendString:@", readwrite) "];
    } else {
        [string appendString:@") "];
    }
    if ([type isEqualToString:kATPAssignTriggerString]) {
        [string appendString:@"<#type#> <#value#>;"];
    } else {
        [string appendString:@"<#type#> *<#value#>;"];
    }
    return string;
}


+ (BOOL)isReadonly:(NSString *)type {
    return [[type substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"r"];
}

+ (BOOL)isReadWrite:(NSString *)type {
    return [[type substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"x"];
}


@end
