//
//  AppDelegate+PushView.m
//  TeamTiger
//
//  Created by xxcao on 2017/2/7.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "AppDelegate+PushView.h"
#import "MMDrawerController.h"
#import "DiscussViewController.h"

@implementation AppDelegate (PushView)

#pragma mark 推送信息展示
//添加推送view
- (void)addPushView
{
    STPushView *topView = [STPushView shareInstance];
    topView.frame = CGRectMake(0, -pushViewHeight, Screen_Width, pushViewHeight);
    [self.window addSubview:topView];
    self.topView = topView;
    topView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudClick)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [topView addGestureRecognizer:tap];
    [tap requireGestureRecognizerToFail:pan];
    topView.gestureRecognizers = @[tap,pan];
}

#pragma mark addPushView相关事件
- (void)hudClick
{
    self.topView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.frame = CGRectMake(0, -pushViewHeight, Screen_Width, pushViewHeight);
    }completion:^(BOOL finished) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self hudClickOperation];
    }];
}

- (void)hudClickOperation
{
    [self push:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.topView.userInteractionEnabled = YES;
    });
}


- (void)pan:(UIPanGestureRecognizer*)pan
{
    CGFloat distance = pushViewHeight-(pushViewHeight-[pan translationInView:self.window].y);
    if (distance<-20) {
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = CGRectMake(0, -pushViewHeight, Screen_Width, pushViewHeight);
        }completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden = NO;
        }];
    }
}

//显示pushView
- (void)displayPushView
{
    [STPushView show];
}

//MARK:- 跳转消息页面
- (void)push:(NSDictionary *)params{
    if(self.topView.msgModel.message_type == 3) {
        //moment变更
        MMDrawerController *drawContoller = (MMDrawerController *)self.window.rootViewController;
        if (drawContoller.openSide != MMDrawerSideNone) {
            TTBaseNavigationController *leftNav = (TTBaseNavigationController *)drawContoller.leftDrawerViewController;
            [leftNav popToRootViewControllerAnimated:NO];
            [drawContoller closeDrawerAnimated:NO completion:nil];
        }
        TTBaseNavigationController *mainNav = (TTBaseNavigationController *)drawContoller.centerViewController;
        if (![mainNav.topViewController isKindOfClass:[DiscussViewController class]]) {
            [mainNav popToRootViewControllerAnimated:NO];
            DiscussViewController *discussVC = [[DiscussViewController alloc] init];
            if (self.topView.msgModel) {
                discussVC.messageModel = self.topView.msgModel;
            }
            [mainNav pushViewController:discussVC animated:YES];
        }
    } else if (self.topView.msgModel.message_type == 1) {
        //项目变更
        MMDrawerController *drawContoller = (MMDrawerController *)self.window.rootViewController;
        if (drawContoller.openSide == MMDrawerSideLeft) {
            TTBaseNavigationController *leftNav = (TTBaseNavigationController *)drawContoller.leftDrawerViewController;
            [leftNav popToRootViewControllerAnimated:YES];
        } else if (drawContoller.openSide == MMDrawerSideNone) {
            TTBaseNavigationController *mainNav = (TTBaseNavigationController *)drawContoller.centerViewController;
            [mainNav popToRootViewControllerAnimated:NO];
            [drawContoller openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
    }
}

@end
