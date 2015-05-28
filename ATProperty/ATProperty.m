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

- (void) textStorageDidChange:(NSNotification *)noti {

    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[noti object];
        ATTextResult *currentLineResult = [textView at_textResultOfCurrentLine];
        if ([self shouldTrigger:currentLineResult.string]) {
            [textView setSelectedRange:NSMakeRange(textView.at_currentCurseLocation - 2, 2)];
            [textView insertText:[self insertTextWithType:currentLineResult.string]];
        }
    }
}


- (BOOL)shouldTrigger:(NSString *)currentLineResult {
    NSArray *array = @[kATPStrongTriggerString, kATPWeakTriggerString, kATPCopyTriggerString, kATPAssignTriggerString];
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
    NSMutableString *string;
    if ([[ATPropertySetting defaultSetting] useNonatomic]) {
        if ([[ATPropertySetting defaultSetting] atomicityPrefix]) {
            if ([type isEqualToString:kATPStrongTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(nonatomic, strong"];
            } else if ([type isEqualToString:kATPWeakTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(nonatomic, weak"];
            } else if ([type isEqualToString:kATPCopyTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(nonatomic, copy"];
            } else if ([type isEqualToString:kATPAssignTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(nonatomic, assign"];
            }
        } else {
            if ([type isEqualToString:kATPStrongTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(strong, nonatomic"];
            } else if ([type isEqualToString:kATPWeakTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(weak, nonatomic"];
            } else if ([type isEqualToString:kATPCopyTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(copy, nonatomic"];
            } else if ([type isEqualToString:kATPAssignTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(assign, nonatomic"];
            }
        }
    } else {
        if ([[ATPropertySetting defaultSetting] atomicityPrefix]) {
            if ([type isEqualToString:kATPStrongTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(atomic, strong"];
            } else if ([type isEqualToString:kATPWeakTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(atomic, weak"];
            } else if ([type isEqualToString:kATPCopyTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(atomic, copy"];
            } else if ([type isEqualToString:kATPAssignTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(atomic, assign"];
            }
        } else {
            if ([type isEqualToString:kATPStrongTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(strong, atomic"];
            } else if ([type isEqualToString:kATPWeakTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(weak, atomic"];
            } else if ([type isEqualToString:kATPCopyTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(copy, atomic"];
            } else if ([type isEqualToString:kATPAssignTriggerString]) {
                string = [[NSMutableString alloc] initWithString:@"(assign, atomic"];
            }
        }
    }
    [string appendString:@") "];
    if ([type isEqualToString:kATPAssignTriggerString]) {
        [string appendString:@"<#type#> <#value#>;"];
    } else {
        [string appendString:@"<#type#> *<#value#>;"];
    }
    return string;
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