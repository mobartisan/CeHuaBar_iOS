//
//  AppDelegate.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UIViewController *)creatHomeVC;
- (void)initialGlobalData;
@end

