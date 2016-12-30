//
//  LoginManager.h
//  TeamTiger
//
//  Created by xxcao on 2016/12/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ResponseStatusSuccess = 0,
    ResponseStatusFailure,
    ResponseStatusOffline,
} EResponseType;

typedef void(^ResponseBlock)(EResponseType resType, id response);

@interface LoginManager : NSObject

@property(assign, nonatomic) BOOL isLogin;//判断当前是否登录

+ (instancetype)sharedInstace;

- (BOOL)isCanAutoLogin;

- (void)loginAppWithParameters:(id)tempDic Response:(ResponseBlock) resBlock;

@end
