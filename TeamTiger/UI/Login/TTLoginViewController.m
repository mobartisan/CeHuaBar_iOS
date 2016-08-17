//
//  TTLoginViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTLoginViewController.h"
#import "UIControl+YYAdd.h"
#import "AppDelegate.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "WXApi.h"
#import "UIAlertView+HYBHelperKit.h"
#import "NetworkManager.h"
@interface TTLoginViewController ()

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
//1.跳转页面
        UIViewController *rootVC = [kAppDelegate creatHomeVC];
        UIWindow *window = kAppDelegate.window;
        window.rootViewController = rootVC;
        [window makeKeyAndVisible];

//2.微信跳转
//
//        if ([WXApi isWXAppInstalled]) {
//            [WXApiRequestHandler sendAuthRequestScope:kAuthScope
//                                                State:kAuthState
//                                               OpenID:kAuthOpenID
//                                     InViewController:self];
//        } else {
//            [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"确定"] block:nil];
//        }

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
