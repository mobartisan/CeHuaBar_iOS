//
//  TTBaseNavigationController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseNavigationController.h"

@interface TTBaseNavigationController ()

@end

@implementation TTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = kColorForBackgroud;
    self.navigationBar.translucent  = NO;
    
    //去掉NavigationBar 下面的横线
//    self.navigationBar.clipsToBounds = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    
    //开启滑动返回手势
//    self.interactivePopGestureRecognizer.delegate = nil;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                          NSShadowAttributeName : shadow,
                          NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0]};
    [self.navigationBar setTitleTextAttributes:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
