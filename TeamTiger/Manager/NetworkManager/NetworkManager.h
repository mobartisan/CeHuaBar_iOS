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


@interface HTTPManager : AFHTTPSessionManager

+ (instancetype)manager;

@end

@interface NetworkManager : NSObject

+ (void)configerNetworking;

@end

//MARK: - 注册
@interface RegisterApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 删除用户数据
@interface DeleteAllDataApi : LCBaseRequest<LCAPIRequest>

@end

#pragma mark - -----------用户-------------
//MARK: - 用户登录
@interface LoginApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 退出登出
@interface ExistAppApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 修改用户信息
@interface UserUpdateApi : LCBaseRequest<LCAPIRequest>

@end


//MARK: - 根据昵称查询用户
@interface UserSearchApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 上传用户client id
@interface UploadClientIdApi : LCBaseRequest<LCAPIRequest>

@end


//MARK: - 获取与当前用户存在项目关系的用户
@interface UserRelationApi : LCBaseRequest<LCAPIRequest>

@end

#pragma mark - -----------项目-------------
//MARK: - 创建项目
@interface ProjectCreateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 移交项目
@interface ProjectHandoverApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 修改项目信息
@interface ProjectUpdateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 获取项目列表
@interface AllProjectsApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 获取项目人员
@interface ProjectMemberListApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 获取指定分组下的项目
@interface ProjectsApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 修改项目置顶状态
@interface ProjectTopApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 修改项目免打扰状态
@interface ProjectDisturbApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 邀请人员加入项目
@interface ProjectMemberInviteApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 移除项目人员
@interface ProjectMemberDeleteApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 项目人员加入项目
@interface ProjectMemberJoinApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 退出项目
@interface ProjectMemberQuitApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 解散项目
@interface ProjectDeleteApi : LCBaseRequest<LCAPIRequest>

@end

#pragma mark - -----------分组-------------
//MARK: - 创建分组
@interface GroupCreatApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 获取分组列表及项目列表（即首页）
@interface AllGroupsApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 修改分组名称
@interface GroupUpdateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 删除分组
@interface GroupDeleteApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: -  移除分组中的项目
@interface DeleteProjectApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: -  修改分组下的项目
@interface MoveProjectApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 获取所有分组列表AllGroupsListApi
@interface AllGroupsListApi : LCBaseRequest<LCAPIRequest>

@end

#pragma mark - -----------moments-------------
//MARK: - 添加Moments
@interface MomentCreateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 查找所有的Moments
@interface AllMomentsApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 添加discuss
@interface DiscussCreateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 创建投票
@interface VoteCreateApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 参与投票
@interface VoteClickApi : LCBaseRequest<LCAPIRequest>

@end

//MARK: - 上传封面图片
@interface UploadImageApi : LCBaseRequest<LCAPIRequest>

@end

#pragma mark - 未用接口
//MARK: - 上传图片
@interface ImageUploadApi : LCBaseRequest<LCAPIRequest>

@property(nonatomic,strong)UploadModel *uploadModel;

@end






