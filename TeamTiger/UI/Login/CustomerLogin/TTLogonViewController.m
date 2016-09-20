

//
//  LogInController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "TTLogonViewController.h"
#import "AppDelegate.h"

#import "DJRegisterView.h"

#import "TTRegisterViewController.h"//用户注册
#import "TTLookForPsdViewController.h"//找回密码
#import "DeviceManager.h"

@interface TTLogonViewController ()

@end

@implementation TTLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf;
    DJRegisterView *registerView = [[DJRegisterView alloc]
                                    initwithFrame:
                                    self.view.bounds
                                    djRegisterViewType:DJRegisterViewTypeNav action:^(NSString *acc, NSString *key) {
                                        NSLog(@"点击了登录");
                                        NSLog(@"\n输入的账户%@\n密码%@",acc,key);
                                        [wself loginActionUserName:acc Password:key];
                                    } zcAction:^{
                                        NSLog(@"点击了 注册");
                                        [wself registerAction:nil];
                                        //test Register
//                                        [wself testRegister];
                                    } wjAction:^{
                                        NSLog(@"点击了   忘记密码");
                                        [wself forgetPasswordAction:nil];
                                    }];
    [self.view addSubview:registerView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma -mark

#pragma -mark test register
- (void)testRegister {
    RegisterApi *registerApi = [[RegisterApi alloc] init];
    
//    registerApi.requestArgument = @{@"username":@"Liupeng",@"password":@"111111",@"passwordConfirmation":@"111111"};
    
    registerApi.requestArgument = @{@"username":@"Chenjie",@"password":@"11111111",@"nick_name":@"huabaCJ",
                                    @"phone":@"iphone",@"os_type":[[DeviceManager sharedInstance] getDeviceType],
                                    @"os_description":[[DeviceManager sharedInstance] iphoneType],
                                    @"device_identify":[[DeviceManager sharedInstance] getDeviceType],
                                    @"passwordConfirmation":@"11111111"};
    LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self Text:@"注册中..."];
    [registerApi addAccessory:accessary];
    [registerApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
//            gSession = request.responseJSONObject[OBJ][@"token"];
//            //do something
//            //        1.data
//            //        2.UI
//            [self jumpToRootVC];
        } else {
            //登录失败
            [super showHudWithText:request.responseJSONObject[MSG]];
            [super hideHudAfterSeconds:3.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@",error.description);
        [super showHudWithText:@"您的网络好像有问题~"];
        [super hideHudAfterSeconds:3.0];
    }];
}

#pragma -mark login register password action
- (void)loginActionUserName:(NSString *)userName Password:(NSString *)password {
#if 1
    [self jumpToRootVC];
#else
    
    if ([Common isEmptyString:userName] || [Common isEmptyString:password]) {
        [super showHudWithText:@"用户名或密码不能为空"];
        [super hideHudAfterSeconds:3.0];
        return;
    }
    LoginApi *loginApi = [[LoginApi alloc] init];
    //username: zhaorui,liupeng,xingxing,bianke,chenjie
    //password: 123456
    loginApi.requestArgument = @{@"username":userName,@"password":password};
    LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self Text:@"登录中..."];
    [loginApi addAccessory:accessary];
    [loginApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            gSession = request.responseJSONObject[OBJ][@"token"];
            //do something
            //        1.data
            //        2.UI
            [self jumpToRootVC];
        } else {
            //登录失败
            [super showHudWithText:request.responseJSONObject[MSG]];
            [super hideHudAfterSeconds:3.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@",error.description);
        [super showHudWithText:@"您的网络好像有问题~"];
        [super hideHudAfterSeconds:3.0];
    }];
#endif
}

- (void)registerAction:(id)sender {
    TTRegisterViewController *registerVC = [[TTRegisterViewController alloc] init];
    TTBaseNavigationController *nav = [[TTBaseNavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)forgetPasswordAction:(id)sender {
    TTLookForPsdViewController *lookforPassVC = [[TTLookForPsdViewController alloc] init];
    TTBaseNavigationController *nav = [[TTBaseNavigationController alloc] initWithRootViewController:lookforPassVC];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma -mark
- (void)jumpToRootVC {
    UIViewController *rootVC = [kAppDelegate creatHomeVC];
    UIWindow *window = kAppDelegate.window;
    window.rootViewController = rootVC;
    [window makeKeyAndVisible];
}

@end
