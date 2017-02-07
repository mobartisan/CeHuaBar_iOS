//
//  ButtonIndexPath.m
//  BBSDemo
//
//  Created by Dale on 16/11/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 事件id
static NSString *const event_id_voteOptionType = @"voteOptionType";//投票类型 单选或者多选

@interface Analyticsmanager : NSObject

+ (instancetype)mainAnalyticsmanager;

+ (void)startAppAnalytics;
//页面统计
+ (void)beginAnalyticsWithViewControllerId:(NSString *)vcId;
+ (void)endAnalyticsWithViewControllerId:(NSString *)vcId;

//自定义事件统计
+ (void)eventWithEventId:(NSString *)eventId withLabel:(NSString *)label withParameters:(NSDictionary *)parameters;

@end
