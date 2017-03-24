//
//  KeyboardManager.m
//  TeamTiger
//
//  Created by xxcao on 2017/3/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "KeyboardManager.h"
#import "STPushView.h"

@interface KeyboardManager ()

@property (nonatomic, assign) BOOL keyboardIsVisible;

@end

@implementation KeyboardManager

static KeyboardManager *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification  object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
        _keyboardIsVisible = NO;
    }
    return self;
}

- (void)keyboardDidShow {
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide {
    _keyboardIsVisible = NO;
    //键盘收起时 查看需不需要发送更新数据的通知
    if (self.messageObject && [self.messageObject isKindOfClass:[TT_Message class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_MESSAGE_COMING object:self.messageObject];
        self.messageObject = nil;
    }
}

- (BOOL)keyboardIsVisible {
    return _keyboardIsVisible;
}

@end
