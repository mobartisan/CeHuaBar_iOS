//
//  ButtonIndexPath.m
//  BBSDemo
//
//  Created by Dale on 16/11/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "Analyticsmanager.h"
#import "TalkingData.h"

#define kTalkingDataAppID  @"974AE9A3D8404A4A93028F93942C8F6A" 
//974AE9A3D8404A4A93028F93942C8F6A  BBS
//E3FC4C86AED54016A223A2D722D1D8FC  个人测试
@implementation Analyticsmanager

+ (instancetype)mainAnalyticsmanager {
    static Analyticsmanager *analyticManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analyticManager = [[Analyticsmanager alloc] init];
    });
    return analyticManager;
}

+ (void)startAppAnalytics {
    //捕捉程序崩溃记录
    [TalkingData setExceptionReportEnabled:YES];
    //捕捉异常信号
    [TalkingData setSignalReportEnabled:YES];
#ifndef __OPTIMIZE__
    //debug 统计日志开关
    [TalkingData setLogEnabled:YES];
#else
    //release
    [TalkingData setLogEnabled:NO];
#endif
    //初始化统计实例
     [TalkingData sessionStarted:kTalkingDataAppID withChannelId:@"AppStore"];
}

+ (void)beginAnalyticsWithViewControllerId:(NSString *)vcId {
    [TalkingData trackPageBegin:vcId];
    
}

+ (void)endAnalyticsWithViewControllerId:(NSString *)vcId {
    [TalkingData trackPageEnd:vcId];
    
}

+ (void)eventWithEventId:(NSString *)eventId withLabel:(NSString *)label withParameters:(NSDictionary *)parameters {
    if (label && !parameters) {
        [TalkingData trackEvent:eventId label:label];
    } else if (label && parameters) {
        [TalkingData trackEvent:eventId label:label parameters:parameters];
    } else {
        [TalkingData trackEvent:eventId];
    }
}


@end
