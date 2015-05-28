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
        if (currentLineResult) {
            [textView setSelectedRange:NSMakeRange(textView.at_currentCurseLocation - 2, 2)];
            [textView insertText:[self insertTextWithType:currentLineResult.string]];
        }
    }
}

- (NSString *)insertTextWithType:(NSString *)type {
    if ([type isEqualToString:kATPStrongTriggerString]) {
        return @"@property (nonatomic, strong) <#type#> *<#value#>;";
    } else if ([type isEqualToString:kATPWeakTriggerString]) {
        return @"@property (nonatomic, weak) <#type#> *<#value#>;";
    } else if ([type isEqualToString:kATPCopyTriggerString]) {
        return @"@property (nonatomic, copy) <#type#> *<#value#>;";
    } else if ([type isEqualToString:kATPAssignTriggerString]) {
        return @"@property (nonatomic, assign) <#type#> <#value#>;";
    }
    return nil;
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