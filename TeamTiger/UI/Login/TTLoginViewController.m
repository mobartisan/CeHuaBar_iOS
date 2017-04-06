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
#import "AppDelegate+PushView.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "WXApi.h"
#import "UIAlertView+HYBHelperKit.h"
#import "NetworkManager.h"
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
        [self loginButtonAction];
    }];
    
    //launch image
    self.screenImageView = [[UIImageView alloc] initWithImage:[UIImage ty_getLaunchImage]];
    [self.screenImageView showInView:self.view animation:[TYLaunchFadeScaleAnimation fadeScaleAnimation] completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
    
    [self autoLogin];

}

//自动登录 逻辑判断
- (void)autoLogin {
    if ([[LoginManager sharedInstace] isCanAutoLogin]) {
        //自动登录
        NSString *accessToken = UserDefaultsGet(WX_ACCESS_TOKEN);
        NSString *openID = UserDefaultsGet(WX_OPEN_ID);
        [[LoginManager sharedInstace] getAccessToken:accessToken OpenId:openID Response:^(EResponseType resType, id response) {
            if (resType == ResponseStatusSuccess ||
                resType == ResponseStatusFailure) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self startLogin:tempDic];
            } else {
                NSLog(@"获取access_token时出错 = %@", response);
                [super showHudWithText:@"登录微信失败"];
                [super hideHudAfterSeconds:1.0];
                [self hideLaunchImage];//隐藏启动页
            }
        }];
    } else {
        //隐藏 手动登录
        [self hideLaunchImage];//隐藏启动页
    }
}


#pragma -mark 跳转微信回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    HTTPManager *manager = [HTTPManager manager];
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
            //微信登录
            [[LoginManager sharedInstace] getAccessToken:accessToken OpenId:openID Response:^(EResponseType resType, id response) {
                if (resType == ResponseStatusSuccess ||
                    resType == ResponseStatusFailure) {
                    [self startLogin:response];
                } else {
                    [super showHudWithText:@"登录微信失败"];
                    [super hideHudAfterSeconds:1.0];
                    [self hideLaunchImage];//隐藏启动页
                }
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
        [self hideLaunchImage];//隐藏启动页
    }];
}

#pragma -mark 登录相关
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
                if (![Common isEmptyString:gMessageType]) {
                    //由apns唤起的
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        TT_Message *message = [[TT_Message alloc] init];
                        message.message_type = gMessageType.integerValue;
                        [appdelegate push:message];
                        gMessageType = nil;
                    });
                }
                [self hideLaunchImage];
            });
        } else if (resType == ResponseStatusFailure) {
            [super showText:response afterSeconds:1.0];
            [self hideLaunchImage];
        } else {
            NSLog(@"%@", response);
            [super showText:@"登录失败" afterSeconds:1.0];
            [self hideLaunchImage];
        }
    }];
}

- (void)loginButtonAction {
    if (![Common isEmptyString:serviceVersion]) {
    }
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
#if TARGET_IPHONE_SIMULATOR
            if (buttonIndex == 0) {
                UIViewController *rootVC = [kAppDelegate creatHomeVC];
                UIWindow *window = kAppDelegate.window;
                window.rootViewController = rootVC;
                [window makeKeyAndVisible];
            }
#endif
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

@end
