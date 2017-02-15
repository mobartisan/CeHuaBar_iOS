//
//  DiscussListModel.m
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DiscussListModel.h"

@implementation DiscussListModel


- (void)setUpdate_at:(NSString *)update_at {
    NSString *update_dateStr = [Common handleDateMonthDayHourMinuteSecond:[self timeWithTimeIntervalString:update_at]];
    NSString *currentStr = [Common getCurrentSystemMonthDayHourMinuteSecond];
    NSLog(@"%@--%@", update_dateStr, currentStr);
    _update_at = [self compareStartTime:update_dateStr endTime:currentStr];
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSString *)compareStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"MM月dd日 HH:mm:ss";
    // 截止时间data格式
    NSDate *startDate = [dateFomatter dateFromString:startTime];
    // 当前时间data格式
    NSDate *endDate = [dateFomatter dateFromString:endTime];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    if (dateCom.month > 0 || dateCom.day > 0 || dateCom.hour > 0) {
        return  [Common handleDateMonthDayHourMinute:startTime];
    } else {
        if (dateCom.minute > 0) {
            return [NSString stringWithFormat:@"%ld分钟之前", dateCom.minute];
        }
        return [NSString stringWithFormat:@"1分钟之前"];
    }
    
}

@end
