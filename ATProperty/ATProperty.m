//
//  ATProperty.m
//  ATProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "ATProperty.h"
#import "ATTextResult.h"
#import "ATPropertySetting.h"
#import "NSTextView+TextGetter.h"
#import "NSString+TextGetter.h"
#import "ATPropertySetting.h"

static ATProperty *sharedPlugin;

@interface ATProperty()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@end

@implementation ATProperty

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textStorageDidChange:)
                                                     name:NSTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void) textStorageDidChange:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        ATTextResult *currentLineResult = [textView at_textResultOfCurrentLine];
        if ([self shouldTrigger:currentLineResult.string]) {
            NSUInteger length = currentLineResult.string.length;
            [textView setSelectedRange:NSMakeRange(textView.at_currentCurseLocation - length, length)];
            [textView insertText:[self insertTextWithType:currentLineResult.string]];
        }
    }
}

- (BOOL)shouldTrigger:(NSString *)currentLineResult {
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

- (NSString *)insertTextWithType:(NSString *)type {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:@"@property "];
    [ms appendString:[self modifiedSymbolTupleWithType:type]];
    return ms;
}

- (NSString *)modifiedSymbolTupleWithType:(NSString *)type {
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


- (BOOL)isReadonly:(NSString *)type {
    return [[type substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"r"];
}

- (BOOL)isReadWrite:(NSString *)type {
    return [[type substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"x"];
}

- (void)addMenuItem {
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"@property" action:@selector(doMenuAction) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)doMenuAction {
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end