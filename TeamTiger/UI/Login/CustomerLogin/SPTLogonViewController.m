

//
//  LogInController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "SPTLogonViewController.h"
#import "AppDelegate.h"

#import "DJRegisterView.h"

#import "SPTRegisterViewController.h"//用户注册
#import "SPTLookForPsdViewController.h"//找回密码

@interface SPTLogonViewController ()

@end

@implementation SPTLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DJRegisterView *registerView = [[DJRegisterView alloc]
                                    initwithFrame:
                                    self.view.bounds
                                    djRegisterViewType:DJRegisterViewTypeNav action:^(NSString *acc, NSString *key) {
                                        NSLog(@"点击了登录");
                                        NSLog(@"\n输入的账户%@\n密码%@",acc,key);
                                        [self loginAction:nil];
                                        
                                    } zcAction:^{
                                        NSLog(@"点击了 注册");
                                        [self registerAction:nil];
                                    } wjAction:^{
                                        NSLog(@"点击了   忘记密码");
                                        [self forgetPasswordAction:nil];
                                    }];
    [self.view addSubview:registerView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma -mark
#pragma -mark login register password action
- (void)loginAction:(id)sender {
    
}

- (void)registerAction:(id)sender {
    SPTRegisterViewController *registerVC = [[SPTRegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)forgetPasswordAction:(id)sender {
    SPTLookForPsdViewController *lookforPassVC = [[SPTLookForPsdViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lookforPassVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
