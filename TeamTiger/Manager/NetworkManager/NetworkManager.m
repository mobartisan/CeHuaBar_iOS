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
    config.mainBaseUrl = Dev_Server;
    LCProcessFilter *filter = [[LCProcessFilter alloc] init];
    config.processRule = filter;
}

@end

@implementation RegisterApi

- (NSString *)apiMethodName {
    return @"bbs/api/v1.0/user/register.app";
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

//- (LCRequestSerializerType)requestSerializerType {
//    return LCRequestSerializerTypeHTTP;
//}

@end

@implementation LoginApi

- (NSString *)apiMethodName {
    return @"bbs/api/v1.0/user/login.app";
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
    return @"bbs/api/v1.0/moment/list.app";
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
    return @"bbs/api/v1.0/project/add.app";
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
    return @"bbs/api/v1.0/point2.app";
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
    return @"bbs/api/v1.0/moment/add.app";
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
    return @"bbs/api/v1.0/discuss/add.app";
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
    return @"bbs/api/v1.0/project/list.app";
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
    return @"bbs/api/v1.0/point2.app";
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
    return @"bbs/api/v1.0/group/list.app";
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
    return @"bbs/api/v1.0/group/project/list.app";
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
    return @"bbs/api/v1.0/group/project/delete.app";
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
    return @"bbs/api/v1.0/group/project/move.app";
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
    return @"bbs/api/v1.0/group/add.app";
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


//创建投票Moment
@implementation VoteCreateApi

- (NSString *)apiMethodName {
    return @"bbs/api/v1.0/vote/add.app";
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



