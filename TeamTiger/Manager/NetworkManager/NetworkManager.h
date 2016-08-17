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

@interface NetworkManager : NSObject

+ (void)configerNetworking;

@end

//登录
@interface LoginApi : LCBaseRequest<LCAPIRequest>

@end

@interface TestApi : LCBaseRequest<LCAPIRequest>

@end

//项目
@interface ProjectsApi : LCBaseRequest<LCAPIRequest>

@end

//项目详情
@interface ProjectDetailApi : LCBaseRequest<LCAPIRequest>

@end

//创建项目
@interface ProjectCreateApi : LCBaseRequest<LCAPIRequest>

@end

//退出项目
@interface ProjectExitApi : LCBaseRequest<LCAPIRequest>

@end


//讨论
@interface DiscussesApi : LCBaseRequest<LCAPIRequest>

@end

//创建讨论
@interface DiscussCreateApi : LCBaseRequest<LCAPIRequest>

@end

//删除讨论
@interface DiscussDeleteApi : LCBaseRequest<LCAPIRequest>

@end

//评论
@interface CommentsApi : LCBaseRequest<LCAPIRequest>

@end

//创建评论
@interface CommentCreateApi : LCBaseRequest<LCAPIRequest>

@end

//删除评论
@interface CommentDeleteApi : LCBaseRequest<LCAPIRequest>

@end


@interface ImageUploadApi : LCBaseRequest<LCAPIRequest>

@end
