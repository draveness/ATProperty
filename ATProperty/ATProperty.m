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
#import "ATPSettingPanelWindowController.h"
#import "ATPStringGenerator.h"

static ATProperty *sharedPlugin;

@interface ATProperty()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) ATPSettingPanelWindowController *settingPanel;

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
        [self addMenuItem];
    }
    return self;
}

- (void)textStorageDidChange:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        ATTextResult *currentLineResult = [textView at_textResultOfCurrentLine];
        if ([ATPStringGenerator shouldTrigger:currentLineResult.string]) {
            NSUInteger length = currentLineResult.string.length;
            [textView setSelectedRange:NSMakeRange(textView.at_currentCurseLocation - length, length)];
            [textView insertText:[ATPStringGenerator insertTextWithType:currentLineResult.string]];
        }
    }
}

- (void)addMenuItem {
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"ATProperty" action:@selector(showSettingPanel) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)showSettingPanel {
    self.settingPanel = [[ATPSettingPanelWindowController alloc] initWithWindowNibName:@"ATPSettingPanelWindowController"];
    [self.settingPanel showWindow:self.settingPanel];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end