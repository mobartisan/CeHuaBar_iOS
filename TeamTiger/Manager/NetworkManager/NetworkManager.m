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

@implementation HTTPManager

static HTTPManager *networkManager = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = (HTTPManager *)[AFHTTPSessionManager manager];
    });
    return networkManager;
}

@end

static double const timeOutInterval = 15.0;

@implementation NetworkManager : NSObject

+ (void)configerNetworking {
    LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
    config.mainBaseUrl = Pro_Server;//Dev_Server
    LCProcessFilter *filter = [[LCProcessFilter alloc] init];
    config.processRule = filter;
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
    return NO;
}

@end

//MARK: - 删除用户数据
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

- (BOOL)cacheResponse {
    return NO;
}



- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

#pragma mark - -----------用户-------------
//MARK: - 用户登录
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
    return NO;
}

@end

//MARK: - 退出登出
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

//MARK: - 上传client id
@implementation UploadClientIdApi

- (NSString *)apiMethodName {
    return @"user/clientid.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 获取与当前用户存在项目关系的用户
@implementation UserRelationApi

- (NSString *)apiMethodName {
    return @"user/relation.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

#pragma mark - -----------项目-------------
//MARK：- 创建项目
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


//MARK: - 移交项目
@implementation ProjectHandoverApi

- (NSString *)apiMethodName {
    return @"project/handover.app";
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

//MARK: - 修改项目信息
@implementation ProjectUpdateApi

- (NSString *)apiMethodName {
    return @"project/update.app";
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

//MARK: - 获取项目列表
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}


- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
    
}

@end

//MARK: - 获取项目人员
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 获取指定分组下的项目
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 修改项目置顶状态
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

//MARK: - 修改项目免打扰状态
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

//MARK: - 邀请人员加入项目
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

//MARK: - 移除项目人员
@implementation ProjectMemberDeleteApi

- (NSString *)apiMethodName {
    return @"project/member/delete.app";
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

//MARK: - 项目人员加入项目
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

//MARK: - 退出项目
@implementation ProjectMemberQuitApi

- (NSString *)apiMethodName {
    return @"project/member/quit.app";
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

//MARK: - 解散项目
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

#pragma mark - -----------分组-------------
//MARK: - 创建分组
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

//MARK: - 获取分组列表及项目列表（即首页）
@implementation AllGroupsApi

- (NSString *)apiMethodName {
    return @"all/list.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 修改分组名称
@implementation GroupUpdateApi

- (NSString *)apiMethodName {
    return @"group/update.app";
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

//MARK: - 删除分组
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

//MARK: -  移除分组中的项目
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

//MARK: -  修改分组下的项目
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

//MARK: - 获取所有分组列表
@implementation AllGroupsListApi

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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end
#pragma mark - -----------moments-------------
//MARK: - 添加Moments
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

//MARK: - 查找所有的Moments
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;

}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 获取Moment详情
@implementation MomentDetailApi

- (NSString *)apiMethodName {
    return @"moment/detail.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
    
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 获取未读消息列表
@implementation MessageListApi

- (NSString *)apiMethodName {
    return @"moment/message/list.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
    
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end


//MARK: - 获取未读消息个数
@implementation MessageCountApi

- (NSString *)apiMethodName {
    return @"moment/message/count.app";
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
    //1.return NO; 不需要缓存
    
    //2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
    
}

- (NSDictionary *)requestHeaderValue {
    return @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
}

@end

//MARK: - 清空未读消息
@implementation DeleteUnreadMessageApi

- (NSString *)apiMethodName {
    return @"moment/message/delete.app";
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


//MARK: - 添加discuss
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

//MARK: - 创建投票
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

//MARK: - 参与投票
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

//MARK: - 上传封面图片
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

#pragma mark - 未用接口
//MARK: - 上传图片
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




