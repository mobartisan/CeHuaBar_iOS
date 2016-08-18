//
//  LookPassController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "TTLookForPsdViewController.h"
#import "DJRegisterView.h"
@interface TTLookForPsdViewController ()

@end

@implementation TTLookForPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";    
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    DJRegisterView *djzcView = [[DJRegisterView alloc]
                                initwithFrame:self.view.bounds djRegisterViewTypeSMS:DJRegisterViewTypeNoScanfSMS plTitle:@"请输入验证码"
                                title:@"提交"
                                
                                hq:^BOOL(NSString *phoneStr) {
                                    
                                    return YES;
                                }
                                
                                tjAction:^(NSString *yzmStr) {
                                    
                                }];
    [self.view addSubview:djzcView];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
