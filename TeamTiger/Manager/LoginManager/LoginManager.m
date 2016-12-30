//
//  LoginManager.m
//  TeamTiger
//
//  Created by xxcao on 2016/12/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "LoginManager.h"


@implementation LoginManager

static LoginManager *loginManager = nil;
+ (instancetype)sharedInstace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!loginManager) {
            loginManager = [[[self class] alloc] init];
        }
    });
    return loginManager;
}

//MARK:--判断是否能够自动登录
- (BOOL)isCanAutoLogin {
    BOOL canAutoLogin = NO;
    NSString *refreshToken = UserDefaultsGet(WX_REFRESH_TOKEN);
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXDoctor_App_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                               error:&error];
    NSString *reAccessToken = [obj objectForKey:WX_ACCESS_TOKEN];
    if (![Common isEmptyString:reAccessToken]) {
        UserDefaultsSave(reAccessToken, WX_ACCESS_TOKEN);
        UserDefaultsSave([obj objectForKey:WX_OPEN_ID], WX_OPEN_ID);
        UserDefaultsSave([obj objectForKey:WX_REFRESH_TOKEN], WX_REFRESH_TOKEN);
        
        id num = UserDefaultsGet(@"LastIsLogOut");
        if ([num intValue] == 1) {
            canAutoLogin = YES;
        }
    }
    return canAutoLogin;
}

//MARK:--登录方法
- (void)loginAppWithParameters:(id)tempDic Response:(ResponseBlock) resBlock{
    LoginApi *login = [[LoginApi alloc] init];
    login.requestArgument = tempDic;
    [login startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            gSession = request.responseJSONObject[OBJ][TOKEN];
            TT_User *user = [TT_User sharedInstance];
            [user createUser:request.responseJSONObject[OBJ][DATA]];
            [SQLITEMANAGER setDataBasePath:user.user_id];
            if ([UserDefaultsGet(@"LastIsLogOut") intValue] != 1) {
                [SQLITEMANAGER createDataBaseIsNeedUpdate:YES isForUser:YES];
            }
            UserDefaultsSave(@1, @"LastIsLogOut");
#warning to do 
            self.isLogin = YES;//表明当前已登录
            if(self.loginSucAfterParas) {
                //如果参数有值，直接干事情
                //to do something
                //end 做完之后记得清空参数队列
            }
            resBlock(ResponseStatusSuccess, request.responseJSONObject);
        } else {
            resBlock(ResponseStatusFailure, request.responseJSONObject[MSG]);
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        resBlock(ResponseStatusOffline, error);
    }];
}

//MARK: --微信刷新token
- (void)getAccessToken:(NSString *)access_Token OpenId:(NSString *)openId Response:(ResponseBlock) resBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, access_Token, openId];
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resBlock(ResponseStatusSuccess,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resBlock(ResponseStatusOffline,error);
    }];
}

@end
