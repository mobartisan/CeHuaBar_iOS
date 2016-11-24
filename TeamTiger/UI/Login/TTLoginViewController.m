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
#import "UIView+TYLaunchAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "TYLaunchFadeScaleAnimation.h"

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
    id num = UserDefaultsGet(@"LastIsLogOut");
    if ([self isCanAutoLogin] && [num intValue] == 1) {
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
        [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                            State:kAuthState
                                           OpenID:kAuthOpenID
                                 InViewController:self];
    } else {
        [UIAlertView hyb_showWithTitle:@"提醒" message:@"不装微信怎么玩儿？" buttonTitles:@[@"去装"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
            if (buttonIndex == 0) {
#warning to do
                UIViewController *rootVC = [kAppDelegate creatHomeVC];
                UIWindow *window = kAppDelegate.window;
                window.rootViewController = rootVC;
                [window makeKeyAndVisible];
            }
        }];
    }
}

- (BOOL)isCanAutoLogin {
    NSString *refreshToken = UserDefaultsGet(WX_REFRESH_TOKEN);
    if([Common isEmptyString:refreshToken]) {
        return NO;
    }
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXDoctor_App_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data || data.length == 0) {
        return NO;
    }
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                               error:&error];
    if (error) {
        NSLog(@"%@",[error description]);
        return NO;
    }
    
    NSString *reAccessToken = [obj objectForKey:WX_ACCESS_TOKEN];
    if (reAccessToken) {
        UserDefaultsSave(reAccessToken, WX_ACCESS_TOKEN);
        UserDefaultsSave([obj objectForKey:WX_OPEN_ID], WX_OPEN_ID);
        UserDefaultsSave([obj objectForKey:WX_REFRESH_TOKEN], WX_REFRESH_TOKEN);
        return YES;
    }
    else {
        return NO;
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
        NSLog(@"请求access的response = %@", responseObject);
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
        NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (![Common isEmptyString:accessToken] && ![Common isEmptyString:openID]) {
            UserDefaultsSave(accessToken, WX_ACCESS_TOKEN);
            UserDefaultsSave(openID, WX_OPEN_ID);
            UserDefaultsSave(refreshToken, WX_REFRESH_TOKEN);
        }
        [self getAccess_Token:accessToken openId:openID];;
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
        NSLog(@"%@", responseObject);
        //1.user
        TT_User *user = [TT_User sharedInstance];
        [user createUser:responseObject];
        //2.隐藏转圈 跳转
        [super showHudWithText:@"登录成功"];
        [super hideHudAfterSeconds:1.0];
        //3.标记变量
        UserDefaultsSave(@1, @"LastIsLogOut");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //4.jump new page
            UIViewController *rootVC = [kAppDelegate creatHomeVC];
            UIWindow *window = kAppDelegate.window;
            window.rootViewController = rootVC;
            [window makeKeyAndVisible];
            [self hideLaunchImage];//隐藏启动页
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
        [super showHudWithText:@"登录微信失败"];
        [super hideHudAfterSeconds:1.0];
        [self hideLaunchImage];//隐藏启动页
    }];
}

@end
