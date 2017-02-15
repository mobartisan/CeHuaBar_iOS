//
//  TTBaseViewController+NotificationHandle.h
//  TeamTiger
//
//  Created by xxcao on 2017/2/15.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

typedef void(^NotificationHanldeBlock)(id notification);

@interface TTBaseViewController (NotificationHandle)

- (void)handleNotificationWithBlock:(NotificationHanldeBlock)block;

@end
