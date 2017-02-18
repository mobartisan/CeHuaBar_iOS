//
//  AppDelegate+PushView.h
//  TeamTiger
//
//  Created by xxcao on 2017/2/7.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (PushView)

- (void)addPushView;

- (void)hudClick;

- (void)hudClickOperation;

//显示pushView
- (void)displayPushView;

//页面跳转
- (void)push:(TT_Message *)params;

@end
