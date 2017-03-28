//
//  CacheManager.h
//  TeamTiger
//
//  Created by xxcao on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//



@class Moments;
@interface CacheManager : NSObject


+ (instancetype)sharedInstance;

//存到数据库中
- (void)saveMomentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list tempDic:(NSDictionary *)tempDic;
//查询moments数据
- (Moments *)selectMomentsFromDataBaseWithTempDic:(NSDictionary *)tempDic;
//更新封面数据
- (void)updateBannerWithTempDic:(NSDictionary *)tempDic bannerUrl:(NSString *)bannerUrl;

@end
