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

/** token 失效的报文
code = 2000,
success = 0,
obj = <null>,
msg = token无效，请重新登录
 */
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
            resBlock(ResponseStatusSuccess, request.responseJSONObject);
        } else {
            resBlock(ResponseStatusFailure, request.responseJSONObject[MSG]);
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        resBlock(ResponseStatusOffline, error);
    }];
}

@end
