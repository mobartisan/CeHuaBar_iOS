//
//  ButtonIndexPath.m
//  BBSDemo
//
//  Created by Dale on 16/11/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Analyticsmanager : NSObject

+ (instancetype)mainAnalyticsmanager;

+ (void)startAppAnalytics;
//页面统计
+ (void)beginAnalyticsWithViewControllerId:(NSString *)vcId;
+ (void)endAnalyticsWithViewControllerId:(NSString *)vcId;

//自定义事件统计
+ (void)eventWithEventId:(NSString *)eventId Label:(NSString *)label Attributes:(NSDictionary *)attributs;

@end
