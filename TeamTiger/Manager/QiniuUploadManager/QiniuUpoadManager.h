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

+ (instancetype)mainQiniuUpoadManager;

/**
 *  生成七牛token
 */
- (void)createToken;

// 获取七牛上传token
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)(NSError *error))failure;

// 上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat progress))progress success:(void (^)(NSArray *urls))success failure:(void (^)(NSError *error))failure;

@end
