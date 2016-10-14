//
//  QiniuUpoadManager.h
//  QiNiuDemo
//
//  Created by Dale on 16/10/14.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import <UIKit/UIKit.h>

@interface QiniuUpoadManager : NSObject

/**
 *  工作空间名称
 */
@property (nonatomic, strong) NSString *scope;
/**
 *  accessKey，可在七牛的密钥管理里查看
 */
@property (nonatomic, strong) NSString *accessKey;
/**
 *  secretKey，可在七牛的密钥管理里查看
 */
@property (nonatomic, strong) NSString *secretKey;
/**
 *  token有效时间，以天为单位，默认为5天
 */
@property (nonatomic, assign) NSInteger liveTime;
/**
 *  上传所需的token
 */
@property (nonatomic, strong) NSString *uploadToken;

+ (instancetype)sharedInstance;



/**
 *  生成七牛token
 */
- (void)createToken;

// 获取七牛上传token
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)())failure;

/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
- (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传多张图片,按队列依次上传
- (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat progress))progress success:(void (^)(NSArray *urls))success failure:(void (^)())failure;

@end
