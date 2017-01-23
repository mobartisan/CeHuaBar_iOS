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
    if(!data) {
        return NO;
    }
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
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
            NSLog(@"LoginApi:%@", request.responseJSONObject);
            gSession = request.responseJSONObject[OBJ][TOKEN];
            TT_User *user = [TT_User sharedInstance];
            [user createUser:request.responseJSONObject[OBJ][DATA]];
            [SQLITEMANAGER setDataBasePath:user.user_id];
            if ([UserDefaultsGet(@"LastIsLogOut") intValue] != 1) {
                [SQLITEMANAGER createDataBaseIsNeedUpdate:YES isForUser:YES];
            }
            UserDefaultsSave(@1, @"LastIsLogOut");

            NSMutableArray *tmpArray = [self getParametersBeforeLogin];
            if(tmpArray && tmpArray.count > 0) {
                //如果参数有值，直接干事情
                //end 做完之后记得清空参数队列
                [self doSomethingAfterLoginSucceed:tmpArray];
            }
            self.isLogin = YES;//表明当前已登录
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

//MARK: --登陆成功之后做事情
- (void)doSomethingAfterLoginSucceed:(NSMutableArray *)paras {
    NSMutableArray *srcArray = [NSMutableArray arrayWithArray:paras];//copy一份
    [paras enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self projectMemberJoin:obj Response:^(EResponseType resType, id response) {
            if (resType == ResponseStatusSuccess) {
                [srcArray removeObject:obj];
                UserDefaultsSave(srcArray, @"USER_DEFAULT_KEY_JOIN");
            }
        }] ;
    }];
}

- (BOOL)saveParametersBeforeLogin:(id)para {
    NSMutableArray *mArray = UserDefaultsGet(@"USER_DEFAULT_KEY_JOIN");
    if (![mArray containsObject:para]) {
        [mArray addObject:para];
        UserDefaultsSave(mArray, @"USER_DEFAULT_KEY_JOIN");
    }
    return YES;
}

- (NSMutableArray *)getParametersBeforeLogin {
    NSMutableArray *mArray = UserDefaultsGet(@"USER_DEFAULT_KEY_JOIN");
    if (mArray && mArray.count > 0) {
        return mArray;
    }
    return nil;
}

//MARK:加入项目
- (void)projectMemberJoin:(NSString *)project_id Response:(ResponseBlock) resBlock{
    ProjectMemberJoinApi *projectMemberJoinApi = [[ProjectMemberJoinApi alloc] init];
    projectMemberJoinApi.requestArgument = @{@"pid":project_id};
    [projectMemberJoinApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[MSG] isEqualToString:@"token无效，请重新登录"]) {
            NSString *accessToken = UserDefaultsGet(WX_ACCESS_TOKEN);
            NSString *openID = UserDefaultsGet(WX_OPEN_ID);
            [self getAccessToken:accessToken OpenId:openID Response:^(EResponseType resType, id response) {
                if (resType == ResponseStatusSuccess ||
                    resType == ResponseStatusFailure) {
                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:response];
                    [self loginAppWithParameters:tempDic Response:^(EResponseType resType, id response) {
                        if (resType == ResponseStatusSuccess) {
                            [self projectMemberJoin:project_id Response:resBlock];
                        }
                    }];
                }
            }];
        }
        else if ([request.responseJSONObject[CODE] intValue] == 2000 ||
                 [request.responseJSONObject[SUCCESS] intValue] == 0) {
            //失败
            resBlock(ResponseStatusFailure,request.responseJSONObject[MSG]);
        }
        else if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            //成功
            resBlock(ResponseStatusSuccess,nil);
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        resBlock(ResponseStatusOffline,error);
    }];
}

@end
