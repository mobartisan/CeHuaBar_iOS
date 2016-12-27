//
//  Common.h
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//去除UITableView多余分割线
+ (void)removeExtraCellLines:(UITableView *)tableView;

//字符串为空检查
+ (BOOL)isEmptyString:(NSString *)sourceStr;
//数组是否为空
+ (BOOL)isEmptyArr:(NSArray *)arr;

//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc Type:(NSString *)animationType SubType:(NSString *)subType;
//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav Type:(NSString *)animationType SubType:(NSString *)subType;

//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;


//返回系统年月日时间 YYYY-MM-DD
+ (NSString *)getCurrentSystemYearMonthDay;
//返回系统时间
+ (NSString *)getCurrentSystemTime;
//系统日期
+ (NSString *)getCurrentSystemDate;

//处理时间
+ (NSString *)handleDate:(NSString *)dateStr;

//比较时间大小
- (NSDateComponents *)differencewithDate:(NSString*)dateString withDate:(NSString*)anotherdateString;

//生成BarItem
+ (UIBarButtonItem *)createBarItemWithTitle:(NSString *)name
                                     Nimage:(UIImage *)nImg
                                     Himage:(UIImage *)hImg
                                       Size:(CGSize)size
                                   Selector:(void (^)())block;

//生成BackBarItem
+ (UIBarButtonItem *)createBackBarButton:(NSString *)name
                                Selector:(void(^)())block;


+ (NSString *)encyptWithDictionary:(NSDictionary *)srcDic;

+ (NSDictionary *)unEncyptWithString:(NSString *)srcStr;

@end
