//
//  TTBaseViewController+NotificationHandle.m
//  TeamTiger
//
//  Created by xxcao on 2017/2/15.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController+NotificationHandle.h"
#import "STPushView.h"

@implementation TTBaseViewController (NotificationHandle)

- (void)handleNotificationWithBlock:(NotificationHanldeBlock)block {
    [[NSNotificationCenter defaultCenter] addCustomObserver:self Name:NOTICE_KEY_MESSAGE_COMING Object:nil Block:^(id  _Nullable sender) {
        NSNotification *notification = (NSNotification *)sender;
        if (notification.object) {
            block(notification.object);
        }
    }];
}

@end
