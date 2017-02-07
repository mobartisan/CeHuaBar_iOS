//
//  AppDelegate+PushView.m
//  TeamTiger
//
//  Created by xxcao on 2017/2/7.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "AppDelegate+PushView.h"
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

- (void)push:(NSDictionary *)params{
/*
    STPushModel *model = [ NSKeyedUnarchiver unarchiveObjectWithFile:KRAPI_PUSH_DATA];
    
    //如果是h5
    if ([model.urlType isEqualToString:@"h5"]) {
        
        BOOL isStore = [[AnalysisUrl sharedInstance] analysisWebUrl:model.url];
        BOOL isGoods = [[AnalysisUrl sharedInstance] analysisGoodsIdWebUrl:model.url];
        BOOL isRedBag =[[AnalysisUrl sharedInstance] analyredBagWebUrl:model.url];
        BOOL istrace =[[AnalysisUrl sharedInstance] analytraceWebUr:model.url];
        BOOL islog =[[AnalysisUrl sharedInstance] analylogWebUrl:model.url];
        if (isStore || isGoods) {
            [[WYPageManager sharedInstance] pushViewControllerWithUrlString:model.url currentUrlString:TRAKER_URL_INDEX];
            
        }
        else if (isRedBag)
        {
            RedBageViewController * regBag =[[RedBageViewController alloc]init];
            NSArray *array = [model.url componentsSeparatedByString:@"="];
            NSString * string = [array lastObject];
            regBag.messageID = string;
            regBag.redType = @"coupon";
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            // 跳转到对应的控制器
            regBag.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:regBag animated:YES];
            return;
        }else if (istrace)
        {
            RedBageViewController * regBag =[[RedBageViewController alloc]init];
            NSString * string = [StrUtils getIdFromURLString:model.url interceptString:@"/trace/"];
            regBag.messageID = string;
            regBag.redType = @"trace";
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            // 跳转到对应的控制器
            regBag.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:regBag animated:YES];
            return;
        }else if (islog)
        {
            RedBageViewController * regBag =[[RedBageViewController alloc]init];
            NSString * string = [StrUtils getIdFromURLString:model.url interceptString:@"/log/"];
            regBag.messageID = string;
            regBag.redType = @"log";
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            // 跳转到对应的控制器
            regBag.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:regBag animated:YES];
            return;
        }
        else{
            if (![model.url isEqualToString:@""]) {
                UIStoryboard *setStoryboard = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
                TotalWebViewController *setVC = [setStoryboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
                setVC.shopUrl = model.url;
                setVC.shopTitle = [model.title isEqualToString:@""] ? @"121店" : model.title;
                UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                setVC.hidesBottomBarWhenPushed = YES;
                [pushClassStance pushViewController:setVC animated:YES];
            }
        }
    }
    else if ([model.urlType isEqualToString:@"native"]){
        
        if ([model.url isEqualToString:@"1"]) {
            //一元体验购 已经删除
            
        }else if ([model.url isEqualToString:@"2"]){
            if (([[STCommonInfo getAuthType] intValue] != 1)) {
                [self createGroundGlass];
            }else{
                STProFitViewController *vc = [[STProFitViewController alloc] init];
                UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                vc.hidesBottomBarWhenPushed = YES;
                [pushClassStance pushViewController:vc animated:YES];
            }
        }else if ([model.url isEqualToString:@"3"]){
            if (([[STCommonInfo getAuthType] intValue] != 1)) {
                [self createGroundGlass];
            }else{
                
                MessageMainVC *messageVC = [[MessageMainVC alloc] init];
                messageVC.hidesBottomBarWhenPushed = YES;
                UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                [pushClassStance pushViewController:messageVC animated:YES];
            }
        }else if ([model.url hasPrefix:@"http://"]&&([model.url rangeOfString:@"client"].location!=NSNotFound)){ //跳转到客服接 界面
            
            NSString *orgIdString =[[AnalysisUrl sharedInstance] extractOrgId:model.url];
            NSString *siteIdString = [[AnalysisUrl sharedInstance] extractOrgIdStoreId:model.url];
            [[WYPageManager sharedInstance] pushViewController:@"TLChatViewController" withParam:
             @{
               @"title_nameString":@"官方客服",
               @"orgIdString":orgIdString,
               @"siteIdString":siteIdString,
               @"currentURL":model.url
               } animated:YES];
            
        }
    }
*/
}

@end
