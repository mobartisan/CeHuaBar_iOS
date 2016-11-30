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
#import "QiniuUploadHelper.h"


@interface QiniuUpoadManager ()

@property (nonatomic, assign) NSInteger index;

@end

static QiniuUpoadManager *manager = nil;

@implementation QiniuUpoadManager

+ (instancetype)sharedInstance {
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

+ (NSString *)getDateTimeString {

    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}


//上传单张图片
- (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
    [QiniuUpoadManager getQiniuUploadToken:^(NSString *token) {
        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [QiniuUpoadManager getDateTimeString], [QiniuUpoadManager randomStringWithLength:8]];
        QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:YES cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
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
                                  failure();
                              }
                          }
                      } option:option];
    } failure:^{
        NSLog(@"获取Token失败");
    }];
    
}

//上传多张图片
- (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            NSLog(@"---%ld",(unsigned long)currentIndex);
            if (currentIndex<imageArray.count) {
                [manager uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
        }
    };
    [manager uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}


//服务器获取七牛的token
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)())failure {
    success([QiniuUpoadManager sharedInstance].uploadToken);
    //网络请求七牛token
  
}


@end
