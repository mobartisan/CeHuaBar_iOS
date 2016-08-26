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


//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc Type:(NSString *)animationType SubType:(NSString *)subType;
//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav Type:(NSString *)animationType SubType:(NSString *)subType;

//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

//返回系统时间
+ (NSString *)getCurrentSystemTime;
@end
