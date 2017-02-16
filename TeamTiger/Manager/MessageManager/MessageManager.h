//
//  MessageManager.h
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"


@interface MessageManager : NSObject<GeTuiSdkDelegate>

+ (instancetype)sharedInstance;

+ (void)registerUserNotification;

+ (BOOL)isMessageNotificationServiceOpen;//判断是否开启推送

+ (void)checkAPNs;

- (void)startGeTui;

- (void)registerDeviceToken:(NSString *)deviceToken;

- (void)handleOneMessage:(id)msgObj IsOffLine:(BOOL)isOffLine;

@end

