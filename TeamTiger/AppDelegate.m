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
#import "WXApiManager.h"
#import "MessageManager.h"
#import "UploadManager.h"
#import "Analyticsmanager.h"
#import "TTProjectsMenuViewController.h"
#import "JKEncrypt.h"
#import "LoginManager.h"
#import "AppDelegate+PushView.h"
#import "KeyboardManager.h"

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
    
    //添加未读消息
    [self addPushView];
    
    //check app version
    [AppDelegate checkAppVersion:^(EResponseType resType, id response) {
        if (resType == ResponseStatusSuccess) {
            [AppDelegate checkApp];
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //计算个数
    [self caculateUnreadMessageCount];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //个推SDK重新上线
    [[MessageManager sharedInstance] startGeTui];
    [MessageManager checkAPNs];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_KEY_RELATED_APNS object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

//MARK: iOS9 before
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"sourceApplication: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    //    if ([sourceApplication isEqualToString:@"com.mobartisan.cehuaBar"]){
    //    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//MARK: iOS9 After
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSLog(@"Calling Application Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    //  方式一：
    //    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
    
    //  方式二：
    if ([url.absoluteString containsString:@"cehuabar"]) {
        NSDictionary *dic = [Common transeforStr2Dic:url.query];
        JKEncrypt *jkEncrypt = [[JKEncrypt alloc] init];
        NSString *project_id = [jkEncrypt doDecEncryptHex:dic[@"project_id"]];
        LoginManager *loginManager = [LoginManager sharedInstace];
        if (loginManager.isLogin) {
            //直接发请求
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.label.text = @"正在帮您加入新的项目。。。";
            hud.mode = MBProgressHUDModeText;
            [loginManager projectMemberJoin:project_id Response:^(EResponseType resType, id response) {
                if (resType == ResponseStatusFailure) {
                    hud.label.text = response;
                } else if (resType == ResponseStatusOffline){
                    hud.label.text = @"网络出错了~";
                } else if (resType == ResponseStatusSuccess){
                    hud.label.text = @"加入新项目成功";
                }
                [hud hideAnimated:YES afterDelay:1.5];
            }];
        } else {
            //如果没登录，保存数据
            [loginManager saveParametersBeforeLogin:project_id];
        }
    }
    else {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
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
    HomeViewController *homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    TTBaseNavigationController *mainNav = [[TTBaseNavigationController alloc] initWithRootViewController:homeVC];

    
    TTProjectsMenuViewController *projectsMenuVC = [[TTProjectsMenuViewController alloc] initWithNibName:@"TTProjectsMenuViewController" bundle:nil];
    TTBaseNavigationController *leftNav = [[TTBaseNavigationController alloc] initWithRootViewController:projectsMenuVC];

    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:mainNav
                                            leftDrawerViewController:leftNav
                                            rightDrawerViewController:nil];
    [drawerController setShowsShadow:NO];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView | MMOpenDrawerGestureModeBezelPanningCenterView];
    //    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningNavigationBar | MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeBezelPanningCenterView];
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
    [KeyboardManager sharedInstance];//全局监听键盘是否弹起
    
    //推送相关
    [MessageManager registerUserNotification];
    [[MessageManager sharedInstance] startGeTui];
    
    //配置网络
    [NetworkManager configerNetworking];
    
    //向微信注册
    [WXApi registerApp:@"wx6103c7337b6114c0" withDescription:@"策话1.0"];
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

//MARK: - 统计未读消息个数
- (void)caculateUnreadMessageCount {
    MessageCountApi *msgCountApi = [[MessageCountApi alloc] init];
    [msgCountApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[CODE] integerValue] == 1000 &&
            [request.responseJSONObject[SUCCESS] integerValue] == 1) {
            NSInteger number = [request.responseJSONObject[OBJ][@"newscount"] integerValue];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
        } else {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    }];
}

//MARK:-版本检测
+ (void)checkAppVersion:(ResponseBlock)passService {
    VersionApi *api = [[VersionApi alloc] init];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[CODE] integerValue] == 1000) {
            serviceVersion = request.responseJSONObject[OBJ][SERVICEVERSION];
            appDescription = request.responseJSONObject[OBJ][DESCRIPTION];
            passService(ResponseStatusSuccess, serviceVersion);
        } else {
            passService(ResponseStatusFailure, request.responseJSONObject[MSG]);
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        passService(ResponseStatusOffline, NETWORKERROR);
    }];
}

+ (void)checkApp {
    NSArray *serArr = [serviceVersion componentsSeparatedByString:@"."];
    NSArray *nowArr = [AppVersion componentsSeparatedByString:@"."];
    if (serArr.count == 3 && nowArr.count == 3) {
        if (![serArr[0] isEqualToString:nowArr[0]]) {
            //大版本
            newVersionType = EAppVersionBig;
            [Common updateVewsin:YES UpdateInfo:appDescription];
        } else {
            if(![serArr[1] isEqualToString:nowArr[1]] || ![serArr[2] isEqualToString:nowArr[2]]) {
                //小版本
                newVersionType = EAppVersionSmall;
                [Common updateVewsin:NO UpdateInfo:appDescription];
            }
        }
    } else {
        //本地与服务器协商不一致 容错处理
        newVersionType = EAppVersionNew;
    }
}

@end
