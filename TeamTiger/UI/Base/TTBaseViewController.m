//
//  TTBaseViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
#import "Analyticsmanager.h"

@interface TTBaseViewController ()

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Analyticsmanager beginAnalyticsWithViewControllerId:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Analyticsmanager endAnalyticsWithViewControllerId:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"生命周期--释放:【%@】",NSStringFromClass([self class]));
}


- (void)showHudWithText:(NSString *)text {
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
}

- (void)hideHud {
    [self.hud hideAnimated:YES];
}

- (void)hideHudAfterSeconds:(int)seconds {
    [self.hud hideAnimated:YES afterDelay:seconds];
}

- (void)showText:(NSString *)text afterSeconds:(int)seconds; {
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:seconds];
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.mode = MBProgressHUDModeText;
    }
    return _hud;
}

@end
