//
//  AppDelegate.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "IQKeyboardManager.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "TTBaseNavigationController.h"
#import "TTLoginViewController.h"
#import "TTTabBarViewController.h"
#import "WXApiManager.h"
#import "MessageManager.h"
#import "UploadManager.h"
#import "Analyticsmanager.h"
#import "TTProjectsMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if(!self.window){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [self initialMethods];
    //login
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];

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
    //个推SDK重新上线
    [[MessageManager sharedInstance] startGeTui];
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


#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    UserDefaultsSave(token, @"CurrentDeviceToken");
    [[MessageManager sharedInstance] registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma -mark initial methods
- (UIViewController *)creatHomeVC {
#if 0
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    TTBaseNavigationController *mainNav = [[TTBaseNavigationController alloc] initWithRootViewController:homeVC];
    return mainNav;
#else
    TTProjectsMenuViewController *projectsMenuVC = [[TTProjectsMenuViewController alloc] initWithNibName:@"TTProjectsMenuViewController" bundle:nil];
    TTBaseNavigationController *leftNav = [[TTBaseNavigationController alloc] initWithRootViewController:projectsMenuVC];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    TTBaseNavigationController *mainNav = [[TTBaseNavigationController alloc] initWithRootViewController:homeVC];
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:mainNav
                                            leftDrawerViewController:leftNav
                                            rightDrawerViewController:nil];
    [drawerController setShowsShadow:NO];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView | MMOpenDrawerGestureModeBezelPanningCenterView];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningNavigationBar | MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeBezelPanningCenterView | MMCloseDrawerGestureModePanningDrawerView];
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    //自定义手势
    [drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecognizeTouch = NO;
        if(drawerController.openSide == MMDrawerSideNone &&
           [gesture isKindOfClass:[UIPanGestureRecognizer class]]){
            TTBaseNavigationController *mainNav = (TTBaseNavigationController *)drawerController.centerViewController;
            //判断哪个控制器可以滑到抽屉
            if([mainNav.topViewController isKindOfClass:[HomeViewController class]]){
                shouldRecognizeTouch = YES;
            }else{
                //返回yes表示可以滑动到左右侧抽屉
                shouldRecognizeTouch = NO;
            }
        }
        return shouldRecognizeTouch;
    }];
    return drawerController;
    
#endif
    
}

- (void)initialMethods {
    //DataBase
    [SQLITEMANAGER setDataBasePath:SYSTEM];
    [SQLITEMANAGER createDataBaseIsNeedUpdate:YES isForUser:NO];
    
    //IQKeyboardManager
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    //推送相关
    [MessageManager registerUserNotification];
    [[MessageManager sharedInstance] startGeTui];

    //配置网络
    [NetworkManager configerNetworking];

    //向微信注册
    [WXApi registerApp:@"wx6103c7337b6114c0" withDescription:@"策话吧1.0"];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    //启动图片上传服务
    UploadManager *uploadManager = [UploadManager sharedInstance];
    [uploadManager startService];
    
    //七牛
    [[QiniuUpoadManager mainQiniuUpoadManager] createToken];
    //应用统计
    [Analyticsmanager startAppAnalytics];
}

@end
