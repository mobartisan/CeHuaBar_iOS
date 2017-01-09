//
//  NetworkManager.m
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "NetworkManager.h"
#import "LCNetworkConfig.h"
#import "LCProcessFilter.h"

static double const timeOutInterval = 15.0;

@implementation NetworkManager : NSObject

+ (void)configerNetworking {
    LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
    config.mainBaseUrl = Pro_Server;//Dev_Server
    LCProcessFilter *filter = [[LCProcessFilter alloc] init];
    config.processRule = filter;
}

@end


//删除用户数据
@implementation DeleteAllDataApi

- (NSString *)apiMethodName {
    return @"user/delete.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodDelete;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}



- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

#pragma mark - 用户
//MARK: - 登录
@implementation LoginApi

- (NSString *)apiMethodName {
    return @"user/login.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

@end

//MARK: - 登出
@implementation ExistAppApi

- (NSString *)apiMethodName {
    return @"user/logout.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 修改用户信息
@implementation UserUpdateApi

- (NSString *)apiMethodName {
    return @"user/update.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 根据昵称查询用户
@implementation UserSearchApi

- (NSString *)apiMethodName {
    return @"user/search.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 注册
@implementation RegisterApi

- (NSString *)apiMethodName {
    return @"user/register.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

@end

//所有的Moments
@implementation AllMomentsApi

- (NSString *)apiMethodName {
    return @"moment/list.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//创建项目
@implementation ProjectCreateApi

- (NSString *)apiMethodName {
    return @"project/add.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

- (LCRequestSerializerType)requestSerializerType {
    return LCRequestSerializerTypeJSON;
}

@end


@implementation ProjectExitApi

- (NSString *)apiMethodName {
    return @"point2.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//创建Moment
@implementation MomentCreateApi

- (NSString *)apiMethodName {
    return @"moment/add.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//创建discuss
@implementation DiscussCreateApi

- (NSString *)apiMethodName {
    return @"discuss/add.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}


- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//上传图片
@implementation ImageUploadApi

- (NSString *)apiMethodName {
    return @"getweather2.aspx";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (AFConstructingBlock)constructingBodyBlock {
    AFConstructingBlock block = ^(id<AFMultipartFormData> formData){
        NSData *data = self.uploadModel.data;
        NSString *name = self.uploadModel.fileName;
        NSString *formKey = self.uploadModel.fileFormKey;
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
    return block;
}

@end

//所有项目名称
@implementation AllProjectsApi

- (NSString *)apiMethodName {
    return @"project/list.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}


- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
    
}

@end

//项目详情
@implementation ProjectDetailApi

- (NSString *)apiMethodName {
    return @"point2.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//分组
@implementation AllGroupsApi

- (NSString *)apiMethodName {
    return @"group/list.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//分组下的项目列表
@implementation ProjectsApi

- (NSString *)apiMethodName {
    return @"group/project/list.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//删除分组下的项目
@implementation DeleteProjectApi

- (NSString *)apiMethodName {
    return @"group/project/delete.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodDelete;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//移动分组下的项目
@implementation MoveProjectApi

- (NSString *)apiMethodName {
    return @"group/project/move.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//添加分组
@implementation GroupCreatApi

- (NSString *)apiMethodName {
    return @"group/add.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//删除分组
@implementation GroupDeleteApi

- (NSString *)apiMethodName {
    return @"group/delete.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodDelete;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//创建投票Moment
@implementation VoteCreateApi

- (NSString *)apiMethodName {
    return @"vote/add.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//投票事件
@implementation VoteClickApi

- (NSString *)apiMethodName {
    return @"vote/update.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//上传图片
@implementation UploadImageApi

- (NSString *)apiMethodName {
    return @"banner/update.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//项目置顶
@implementation ProjectTopApi

- (NSString *)apiMethodName {
    return @"project/top.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//项目免打扰
@implementation ProjectDisturbApi

- (NSString *)apiMethodName {
    return @"project/disturb.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPut;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//项目删除
@implementation ProjectDeleteApi

- (NSString *)apiMethodName {
    return @"project/delete.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodDelete;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//项目人员加入项目
@implementation ProjectMemberJoinApi

- (NSString *)apiMethodName {
    return @"project/member/join.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//邀请人员加入项目
@implementation ProjectMemberInviteApi

- (NSString *)apiMethodName {
    return @"project/member/invite.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//项目人员列表
@implementation ProjectMemberListApi


- (NSString *)apiMethodName {
    return @"project/member/list.app";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


