//
//  NetworkManager.h
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseRequest.h"
#import "LCRequestAccessory.h"
#import "UploadManager.h"

@interface NetworkManager : NSObject

+ (void)configerNetworking;

@end

//删除用户数据
@interface DeleteAllDataApi : LCBaseRequest<LCAPIRequest>

@end


//注册
@interface RegisterApi : LCBaseRequest<LCAPIRequest>

@end

//登录
@interface LoginApi : LCBaseRequest<LCAPIRequest>

@end


//所有的Moments
@interface AllMomentsApi : LCBaseRequest<LCAPIRequest>

@end

//创建项目
@interface ProjectCreateApi : LCBaseRequest<LCAPIRequest>

@end


//创建Moment
@interface MomentCreateApi : LCBaseRequest<LCAPIRequest>

@end

//创建discuss
@interface DiscussCreateApi : LCBaseRequest<LCAPIRequest>

@end


//上传图片
@interface ImageUploadApi : LCBaseRequest<LCAPIRequest>

@property(nonatomic,strong)UploadModel *uploadModel;

@end

//所有项目名称
@interface AllProjectsApi : LCBaseRequest<LCAPIRequest>

@end


//项目详情
@interface ProjectDetailApi : LCBaseRequest<LCAPIRequest>

@end

//退出项目
@interface ProjectExitApi : LCBaseRequest<LCAPIRequest>

@end

//分组
@interface AllGroupsApi : LCBaseRequest<LCAPIRequest>

@end

//分组下的项目列表
@interface ProjectsApi : LCBaseRequest<LCAPIRequest>

@end

//删除分组下的项目
@interface DeleteProjectApi : LCBaseRequest<LCAPIRequest>

@end

//移动分组下的项目
@interface MoveProjectApi : LCBaseRequest<LCAPIRequest>

@end

//添加分组
@interface GroupCreatApi : LCBaseRequest<LCAPIRequest>

@end

//删除分组
@interface GroupDeleteApi : LCBaseRequest<LCAPIRequest>

@end

//创建投票Moment
@interface VoteCreateApi : LCBaseRequest<LCAPIRequest>

@end

//投票事件
@interface VoteClickApi : LCBaseRequest<LCAPIRequest>

@end

//上传图片
@interface UploadImageApi : LCBaseRequest<LCAPIRequest>

@end

//登出
@interface ExistAppApi : LCBaseRequest<LCAPIRequest>

@end

//项目删除
@interface ProjectDeleteApi : LCBaseRequest<LCAPIRequest>

@end

//项目置顶
@interface ProjectTopApi : LCBaseRequest<LCAPIRequest>

@end

//项目免打扰
@interface ProjectDisturbApi : LCBaseRequest<LCAPIRequest>

@end

//项目人员加入项目
@interface ProjectMemberJoinApi : LCBaseRequest<LCAPIRequest>

@end

