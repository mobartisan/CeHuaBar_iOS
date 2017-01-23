//
//  QiniuUpoadManager.m
//  QiNiuDemo
//
//  Created by Dale on 16/10/14.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "QiniuUpoadManager.h"
#import "QNUrlSafeBase64.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "QN_GTM_Base64.h"
#import "UIImage+Extension.h"

@interface QiniuUpoadManager ()

@property (nonatomic, assign) NSInteger index;
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

@property (copy, nonatomic) void (^upLoadSuccessBlock)(NSString *url);
@property (copy, nonatomic) void (^upLoadFailureBlock)();

@end

static QiniuUpoadManager *manager = nil;

@implementation QiniuUpoadManager

+ (instancetype)mainQiniuUpoadManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[QiniuUpoadManager alloc] init];
    });
    return manager;
}

- (void)registerWithScope:(NSString *)scrop
                accessKey:(NSString *)accessKey
                secretKey:(NSString *)secretKey
                 liveTime:(NSInteger)liveTime {
    self.scope = scrop;
    self.accessKey = accessKey;
    self.secretKey = secretKey;
    self.liveTime = liveTime;
}

- (void)createToken {
    [self registerWithScope:QiNiuScope accessKey:QiNiuAccessKey secretKey:QiNiuSecretKey liveTime:defaultLiveTime];
    if (!self.scope.length || !self.accessKey.length || !self.secretKey.length) {
        return;
    }
    // 将上传策略中的scrop和deadline序列化成json格式
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    [authInfo setObject:self.scope forKey:@"scope"];
    [authInfo
     setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] + self.liveTime * 24 * 3600]
     forKey:@"deadline"];
    NSData *jsonData =
    [NSJSONSerialization dataWithJSONObject:authInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    // 对json序列化后的上传策略进行URL安全的base64编码
    NSString *encodedString = [self urlSafeBase64Encode:jsonData];
    
    // 用secretKey对编码后的上传策略进行HMAC-SHA1加密，并且做安全的base64编码，得到encoded_signed
    NSString *encodedSignedString = [self HMACSHA1:self.secretKey text:encodedString];
    
    // 将accessKey、encodedSignedString和encodedString拼接，中间用：分开，就是上传的token
    NSString *token =
    [NSString stringWithFormat:@"%@:%@:%@", self.accessKey, encodedSignedString, encodedString];
    self.uploadToken = token;
}

- (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text {
    NSString *base64 =
    [[NSString alloc] initWithData:[QN_GTM_Base64 encodeData:text] encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}




//上传单张图片
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QiniuUpoadManager getQiniuUploadToken:^(NSString *token) {
            NSError *tempError;
            NSData *data = [UIImage imageData:image];
//            if (UIImagePNGRepresentation(image) == nil) {
//                data = UIImageJPEGRepresentation(image, 0.7);
//            } else {
//                data = UIImagePNGRepresentation(image);
//            }
            if (!data) {
                if (failure) {
                    failure(tempError);
                }
                return;
            }
            NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [Common getCurrentSystemYearMonthDay], [NSString randomStringWithLength:8]];
            QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:YES cancellationSignal:nil];
            QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
            //如果key为nil,默认上传文件保存名称为hash名:resp[@"hash"]
            [uploadManager putData:data
                               key:fileName
                             token:token
                          complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              if (info.statusCode == 200 && resp) {
                                  NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
                                  if (success) {
                                      success(url);
                                  }
                              }else {
                                  if (failure) {
                                      failure(tempError);
                                  }
                              }
                          } option:option];
        } failure:^(NSError *tokenError) {
            NSLog(@"获取Token失败:%@", tokenError);
        }];
    });
}

//上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)(NSError *error))failure {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    NSError *tempError;
    manager.upLoadFailureBlock = ^() {
        failure(tempError);
        return;
    };
    manager.upLoadSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }else {
            if (currentIndex<imageArray.count) {
                [QiniuUpoadManager uploadImage:imageArray[currentIndex] progress:nil success:manager.upLoadSuccessBlock failure:manager.upLoadFailureBlock];
            }
        }
    };
    [QiniuUpoadManager uploadImage:imageArray[0] progress:nil success:manager.upLoadSuccessBlock failure:manager.upLoadFailureBlock];
}


//服务器获取七牛的token
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)(NSError *error))failure {
    success(manager.uploadToken);
    //网络请求七牛token
  
}


@end
