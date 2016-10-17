//
//  TTLoginViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTLoginViewController.h"
#import "UIControl+YYAdd.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "WXApi.h"
#import "UIAlertView+HYBHelperKit.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "Models.h"

@interface TTLoginViewController () <WXApiManagerDelegate>

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIPhone4) {
        self.bottomHeight.constant = 40;
    } else if (isIPhone5) {
        self.bottomHeight.constant = 50;
    } else if (isIPhone6) {
        self.bottomHeight.constant = 60;
    } else if (isIPhone6P) {
        self.bottomHeight.constant = 70;
    }
    [WXApiManager sharedManager].delegate = self;
    [self.loginBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //微信跳转
        if ([WXApi isWXAppInstalled]) {
            [self handleWXLoginAction];
        } else {
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"去装"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 0) {
                    UIViewController *rootVC = [kAppDelegate creatHomeVC];
                    UIWindow *window = kAppDelegate.window;
                    window.rootViewController = rootVC;
                    [window makeKeyAndVisible];
                }
            }];
        }
    }];
}


- (void)handleWXLoginAction {
    NSString *accessToken = UserDefaultsGet(WX_ACCESS_TOKEN);
    NSString *openID = UserDefaultsGet(WX_OPEN_ID);
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];NSString *refreshToken = UserDefaultsGet(WX_REFRESH_TOKEN);
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXDoctor_App_ID, refreshToken];
        [manager GET:refreshUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求reAccess的response = %@", responseObject);
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                UserDefaultsSave(reAccessToken, WX_ACCESS_TOKEN);
                UserDefaultsSave([refreshDict objectForKey:WX_OPEN_ID], WX_OPEN_ID);
                UserDefaultsSave([refreshDict objectForKey:WX_REFRESH_TOKEN], WX_REFRESH_TOKEN);
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                [self getAccess_Token:accessToken openId:openID];
            }
            else {
                [self handleWXLoginAction];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
            [super showHudWithText:@"登录微信失败"];
            [super hideHudAfterSeconds:1.0];
        }];
    }
    else {
        //转圈
        [super showHudWithText:@"正在登录..."];
        [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                            State:kAuthState
                                           OpenID:kAuthOpenID
                                 InViewController:self];
    }
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXDoctor_App_ID, WXDoctor_App_Secret, response.code];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求access的response = %@", responseObject);
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
        NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            UserDefaultsSave(accessToken, WX_ACCESS_TOKEN);
            UserDefaultsSave(openID, WX_OPEN_ID);
            UserDefaultsSave(refreshToken, WX_REFRESH_TOKEN);
        }
        [self getAccess_Token:accessToken openId:openID];;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
    }];
}

- (void)getAccess_Token:(NSString *)access_Token openId:(NSString *)openId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, access_Token, openId];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        //1.user
        TT_User *user = [TT_User sharedInstance];
        [user createUser:responseObject];
        //2.隐藏转圈 跳转
        [super showHudWithText:@"登录成功"];
        [super hideHudAfterSeconds:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //3.jump new page
            UIViewController *rootVC = [kAppDelegate creatHomeVC];
            UIWindow *window = kAppDelegate.window;
            window.rootViewController = rootVC;
            [window makeKeyAndVisible];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
