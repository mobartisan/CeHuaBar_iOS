//
//  LoginManager.h
//  TeamTiger
//
//  Created by xxcao on 2016/12/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

@property(assign, nonatomic) BOOL isLogin;//判断当前是否登录

+ (instancetype)sharedInstace;

- (BOOL)isCanAutoLogin;

- (void)loginAppWithParameters:(id)tempDic Response:(ResponseBlock) resBlock;

- (void)getAccessToken:(NSString *)access_Token OpenId:(NSString *)openId Response:(ResponseBlock) resBlock;

- (void)projectMemberJoin:(NSString *)project_id Response:(ResponseBlock) resBlock;

- (void)uploadClientID:(NSString *)clientID;//上传个推 id

//存队列
- (BOOL)saveParametersBeforeLogin:(id)para;

//取队列
- (NSMutableArray *)getParametersBeforeLogin;

@end
