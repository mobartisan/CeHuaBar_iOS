//
//  ButtonIndexPath.m
//  BBSDemo
//
//  Created by Dale on 16/11/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "Analyticsmanager.h"
#import "TalkingData.h"

#define kTalkingDtaAppKey  @"E3FC4C86AED54016A223A2D722D1D8FC"


@implementation Analyticsmanager

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
     [TalkingData sessionStarted:kTalkingDtaAppKey withChannelId:@"AppStore"];
}

+ (void)beginAnalyticsWithViewControllerId:(NSString *)vcId {
    [TalkingData trackPageBegin:vcId];
    
}

+ (void)endAnalyticsWithViewControllerId:(NSString *)vcId {
    [TalkingData trackPageEnd:vcId];
    
}

+ (void)eventWithEventId:(NSString *)eventId Label:(NSString *)label Attributes:(NSDictionary *)attributs {
    if (label && !attributs) {
        [TalkingData trackEvent:eventId label:label];
    } else if (label && attributs) {
        [TalkingData trackEvent:eventId label:label parameters:attributs];
    } else {
        [TalkingData trackEvent:eventId];
    }
}

@end
