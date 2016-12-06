//
//  TTBaseViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBHelperKitBaseController.h"
#import "MBProgressHUD.h"

@interface TTBaseViewController : HYBHelperKitBaseController

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)showHudWithText:(NSString *)text;

- (void)hideHud;

- (void)hideHudAfterSeconds:(int)seconds;

- (void)showText:(NSString *)text afterSeconds:(int)seconds;

@end
