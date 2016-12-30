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
#import "UIView+TYLaunchAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "NSString+Utils.h"
#import "LoginManager.h"

@interface TTLoginViewController () <WXApiManagerDelegate>

@property (nonatomic,strong)UIImageView *screenImageView;

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIPhone4) {
        self.bottomHeight.constant = 40;
        self.loginBgImgV.image = [UIImage imageNamed:@"loginBG35"];
    } else if (isIPhone5) {
        self.bottomHeight.constant = 50;
        self.loginBgImgV.image = [UIImage imageNamed:@"loginBG40"];
    } else if (isIPhone6) {
        self.bottomHeight.constant = 60;
        self.loginBgImgV.image = [UIImage imageNamed:@"loginBG47"];
    } else if (isIPhone6P) {
        self.bottomHeight.constant = 70;
        self.loginBgImgV.image = [UIImage imageNamed:@"loginBG55"];
    }
    [WXApiManager sharedManager].delegate = self;
    [self.loginBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self login];
    }];
    
    //launch image
    self.screenImageView = [[UIImageView alloc] initWithImage:[UIImage ty_getLaunchImage]];
    [self.screenImageView showInView:self.view animation:[TYLaunchFadeScaleAnimation fadeScaleAnimation] completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    if ([[LoginManager sharedInstace] isCanAutoLogin]) {
        //自动登录
        NSString *accessToken = UserDefaultsGet(WX_ACCESS_TOKEN);
        NSString *openID = UserDefaultsGet(WX_OPEN_ID);
        [self getAccess_Token:accessToken openId:openID];
    } else {
        //隐藏 手动登录
        [self hideLaunchImage];//隐藏启动页
    }
}

- (void)login {
    //微信跳转
    if ([WXApi isWXAppInstalled]) {
        //转圈
        [super showHudWithText:@"正在登录..."];
        BOOL isSuccess = [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                                             State:kAuthState
                                                            OpenID:kAuthOpenID
                                                  InViewController:self];
        if (!isSuccess) {
            [super hideHudAfterSeconds:1.0];
        }
    }else {
        [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"去装"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
            if (buttonIndex == 0) {
#warning to do 没有安装微信....
                UIViewController *rootVC = [kAppDelegate creatHomeVC];
                UIWindow *window = kAppDelegate.window;
                window.rootViewController = rootVC;
                [window makeKeyAndVisible];
            }
        }];
    }
}

- (void)hideLaunchImage {
    //隐藏启动页
    [self.screenImageView hideWithAnimation:[TYLaunchFadeScaleAnimation fadeScaleAnimation] completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
#pragma -mark 跳转微信回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXDoctor_App_ID, WXDoctor_App_Secret, response.code];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if([accessDict.allKeys containsObject:@"errcode"] ||
           [accessDict.allKeys containsObject:@"errmsg"]) {
            [super showHudWithText:@"登录微信失败"];
            [super hideHudAfterSeconds:1.0];
            [self hideLaunchImage];//隐藏启动页
        } else {
            NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
            NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
            NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (![Common isEmptyString:accessToken] && ![Common isEmptyString:openID]) {
                UserDefaultsSave(accessToken, WX_ACCESS_TOKEN);
                UserDefaultsSave(openID, WX_OPEN_ID);
                UserDefaultsSave(refreshToken, WX_REFRESH_TOKEN);
            }
            [self getAccess_Token:accessToken openId:openID];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
        [self hideLaunchImage];//隐藏启动页
    }];
}

#pragma -mark 微信登录
- (void)getAccess_Token:(NSString *)access_Token openId:(NSString *)openId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, access_Token, openId];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#warning to do
        [self startLogin:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
        [self hideLaunchImage];//隐藏启动页
    }];
}

- (void)startLogin:(id)tempDic {
    //
    LoginManager *loginManager = [LoginManager sharedInstace];
    [loginManager loginAppWithParameters:tempDic Response:^(EResponseType resType, id response) {
        if (resType == ResponseStatusSuccess) {
            //1.隐藏转圈 跳转(UI)
            [super showHudWithText:@"登录成功"];
            [super hideHudAfterSeconds:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //4.jump new page
                UIViewController *rootVC = [kAppDelegate creatHomeVC];
                UIWindow *window = kAppDelegate.window;
                window.rootViewController = rootVC;
                [window makeKeyAndVisible];
            });
        } else if (resType == ResponseStatusFailure) {
            [super showText:response afterSeconds:1.0];
        } else {
            NSLog(@"%@", response);
            [super showText:@"登录失败" afterSeconds:1.0];
        }
        [self hideLaunchImage];
    }];
}

//{
//    code = 1000,
//    success = 1,
//    obj = {
//        user_id = 30fb2a10-ba9c-11e6-8d67-8db0a5730ba6,
//        token = eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjMwZmIyYTEwLWJhOWMtMTFlNi04ZDY3LThkYjBhNTczMGJhNiIsImlhdCI6MTQ4MDkyNDk3MSwiZXhwIjoxNDgwOTI4NTcxfQ.gYal01M9UKtgjRPAwS4kYhFp3U0txK-nBLJ5GwQiGD8,
//        data = {
//            _id = 5844e10cdb061496141cd166,
//            uid = 30fb2a10-ba9c-11e6-8d67-8db0a5730ba6,
//            phone = ,
//            nick_name = 我和你💓,
//            city = Nanjing,
//            country = CN,
//            email = ,
//            username = o4vxEmYWRjUw,
//            language = zh_CN,
//            head_img_from = 1,
//            head_img_url = http://wx.qlogo.cn/mmopen/ysyAxM1rgX1e4x1IsebUYCdHrH4JOWc765icBsriaH1awzbE7oLWGNnuMBbkBSV5hfiayzobH0DVWeyV8b3OxTC9ia9TtT2GiadH4/0
//        }
//    },
//    msg = 登录成功
//}

@end
