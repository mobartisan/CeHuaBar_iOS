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
        
//1.跳转页面
#if 0
        UIViewController *rootVC = [kAppDelegate creatHomeVC];
        UIWindow *window = kAppDelegate.window;
        window.rootViewController = rootVC;
        [window makeKeyAndVisible];
//2.微信跳转
#else
        if ([WXApi isWXAppInstalled]) {
            [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                                State:kAuthState
                                               OpenID:kAuthOpenID
                                     InViewController:self];
        } else {
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"确定"] block:nil];
        }
#endif
////3.测试网络
//        
//        LoginApi *loginApi = [[LoginApi alloc] init];
//        loginApi.requestArgument = @{@"username":@"bianke",@"password":@"110110"};
//        LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self];
//            [loginApi addAccessory:accessary];
//            [loginApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//                NSLog(@"%@",request.responseJSONObject);
//                gSession = request.responseJSONObject[@"obj"][@"token"];
//            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//                NSLog(@"%@",error.description);
//            }];
//        
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            ProjectsApi *testApi = [[ProjectsApi alloc] init];
//            LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self];
//            [testApi addAccessory:accessary];
//            [testApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//                NSLog(@"%@",request.responseJSONObject);
//            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//                NSLog(@"%@",error.description);
//            }];
//        });
//
    }];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if ([response.state isEqualToString:kAuthState]) {
        NSString *url = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
        
        NSLog(@"%@", response.code);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
