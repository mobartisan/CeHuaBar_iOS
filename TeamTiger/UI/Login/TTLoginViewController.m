//
//  TTLoginViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTLoginViewController.h"
#import "UIControl+YYAdd.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "WXApi.h"
#import "UIAlertView+HYBHelperKit.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "Models.h"

@interface TTLoginViewController () <WXApiManagerDelegate>

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIPhone4) {
        self.bottomHeight.constant = 40;
    } else if (isIPhone5) {
        self.bottomHeight.constant = 50;
    } else if (isIPhone6) {
        self.bottomHeight.constant = 60;
    } else if (isIPhone6P) {
        self.bottomHeight.constant = 70;
    }
    [WXApiManager sharedManager].delegate = self;
    [self.loginBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //微信跳转
        if ([WXApi isWXAppInstalled]) {
            //转圈
            [super showHudWithText:@"正在登录..."];
            [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                                State:kAuthState
                                               OpenID:kAuthOpenID
                                     InViewController:self];
        } else {
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 0) {
                    UIViewController *rootVC = [kAppDelegate creatHomeVC];
                    UIWindow *window = kAppDelegate.window;
                    window.rootViewController = rootVC;
                    [window makeKeyAndVisible];
                }
            }];
        }
    }];
}


- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if ([response.state isEqualToString:kAuthState]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXDoctor_App_ID, WXDoctor_App_Secret, response.code];
        [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self getAccess_Token:responseObject[@"access_token"] openId:responseObject[@"openid"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"获取access_token时出错 = %@", error);
            [super showHudWithText:@"登录微信失败"];
            [super hideHudAfterSeconds:1.0];
        }];
    } else {
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
    }
}


- (void)getAccess_Token:(NSString *)access_Token openId:(NSString *)openId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, access_Token, openId];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        //1.user
        TT_User *user = [TT_User sharedInstance];
        [user createUser:responseObject];
        //2.隐藏转圈 跳转
        [super showHudWithText:@"登录成功"];
        [super hideHudAfterSeconds:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //3.jump new page
            UIViewController *rootVC = [kAppDelegate creatHomeVC];
            UIWindow *window = kAppDelegate.window;
            window.rootViewController = rootVC;
            [window makeKeyAndVisible];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
