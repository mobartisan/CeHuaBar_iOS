//
//  AppDelegate.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "AppDelegate.h"
#import "CirclesViewController.h"
#import "HomeViewController.h"
#import "IQKeyboardManager.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "TTBaseNavigationController.h"
#import "TTLoginViewController.h"
#import "TTTabBarViewController.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "UIView+TYLaunchAnimation.h"
#import "WXApiManager.h"
#import "CirclesVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if(!self.window){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [self initialMethods];
    [self initialGlobalData];
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] initWithNibName:@"TTLoginViewController" bundle:nil];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];

    //launch image
    UIImageView *screenImageView = [[UIImageView alloc] initWithImage:[UIImage ty_getLaunchImage]];
    [screenImageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeScaleAnimation]
                                    completion:^(BOOL finished) {
                                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                                    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma -mark initial methods
- (UIViewController *)creatHomeVC {
    
//    CirclesViewController *circleVC = [[CirclesViewController alloc] init];
    
    CirclesVC *circleVC = [[CirclesVC alloc] init];
    
    TTBaseNavigationController *leftNav = [[TTBaseNavigationController alloc] initWithRootViewController:circleVC];
//    NSMutableArray *homeVCs = [NSMutableArray array];
//    for (NSString *title in circleVC.titles) {
//        HomeViewController *homeVC = [[HomeViewController alloc] init];
//        homeVC.title = title;
//        [homeVCs addObject:homeVC];
//    }
    
//    TTTabBarViewController *mainTab = [[TTTabBarViewController alloc] initWithChildViewControllers:homeVCs];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    TTBaseNavigationController *mainNav = [[TTBaseNavigationController alloc] initWithRootViewController:homeVC];
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:mainNav
                                            leftDrawerViewController:nil
                                            rightDrawerViewController:leftNav];
    [drawerController setShowsShadow:YES];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    [drawerController setMaximumRightDrawerWidth:Screen_Width];
    //自定义手势
    [drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecognizeTouch = NO;
        if(drawerController.openSide == MMDrawerSideNone &&
           [gesture isKindOfClass:[UIPanGestureRecognizer class]]){
//            TTTabBarViewController *mainTab = (TTTabBarViewController *)drawerController.centerViewController;
            TTBaseNavigationController *mainNav = (TTBaseNavigationController *)drawerController.centerViewController;
//            UINavigationController *nav = (UINavigationController *)mainTab.selectedViewController;
            //判断哪个控制器可以滑到抽屉
            if([mainNav.topViewController isKindOfClass:[HomeViewController class]]
               )
            {
                shouldRecognizeTouch = YES;//返回yes表示可以滑动到左右侧抽屉
            }
        }
        return shouldRecognizeTouch;
    }];
    
    return drawerController;
}

- (void)initialMethods {
    //DataBase
    [SQLITEMANAGER setDataBasePath:SYSTEM];
    [SQLITEMANAGER createDataBaseIsNeedUpdate:YES isForUser:NO];
    
    //IQKeyboardManager
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    
    //配置网络
    [NetworkManager configerNetworking];

    //向微信注册
    [WXApi registerApp:@"wx1c3af3a24b22035c" withDescription:@"策话吧1.0"];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
}

- (void)initialGlobalData {
    //    NSMutableArray *circles = [NSMutableArray arrayWithArray:@[@"所有项目",@"工作牛",@"易会",@"MPP",@"营配"]];
    //    [CacheManager sharedInstance].cacheType = ECacheTypeMemory;
    //    [[CacheManager sharedInstance] setObject:circles ForKey:TTCircle_Cache_Key];
    
    [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
}

@end
