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
//获取安全的字符串
+ (NSString *)safeString:(NSString *)sourceStr;
//处理微信头像
+ (NSString *)handleWeChatHeadImageUrl:(NSString *)headImgUrl Size:(double)size;
//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc Type:(NSString *)animationType SubType:(NSString *)subType;
//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav Type:(NSString *)animationType SubType:(NSString *)subType;
//获取当前视图
+ (UIViewController *)getCurrentVC;
//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;


//返回系统年月日时间 YYYY-MM-DD
+ (NSString *)getCurrentSystemYearMonthDay;
//返回系统时间
+ (NSString *)getCurrentSystemTime;
//系统日期
+ (NSString *)getCurrentSystemDate;
//返回系统月日 时分秒
+ (NSString *)getCurrentSystemMonthDayHourMinuteSecond;

//处理时间
+ (NSString *)handleDate:(NSString *)dateStr;
+ (NSString *)handleDateMonthDayHourMinuteSecond:(NSString *)dateStr;
+ (NSString *)handleDateMonthDayHourMinute:(NSString *)dateStr;
//比较时间大小
+ (NSDateComponents *)differencewithDate:(NSString*)dateString withDate:(NSString*)anotherdateString;

//生成BarItem
+ (UIBarButtonItem *)createBarItemWithTitle:(NSString *)name
                                     Nimage:(UIImage *)nImg
                                     Himage:(UIImage *)hImg
                                       Size:(CGSize)size
                                   Selector:(void (^)())block;

//生成BackBarItem
+ (UIBarButtonItem *)createBackBarButton:(NSString *)name
                                Selector:(void(^)())block;

+ (NSDictionary *)transeforStr2Dic:(NSString *)srcStr;

+ (NSString *)encypt2StrWithDictionary:(NSDictionary *)srcDic UnencyptKeys:(NSArray *)keys Mode:(NSInteger)mode;
+ (NSDictionary *)encypt2DicWithDictionary:(NSDictionary *)srcDic UnencyptKeys:(NSArray *)keys Mode:(NSInteger)mode;

+ (NSDictionary *)unEncypt2StrWithString:(NSString *)srcStr Mode:(NSInteger)mode;
+ (NSDictionary *)unEncypt2DicWithDic:(NSDictionary *)srcDic Mode:(NSInteger)mode;
//生成md5
+ (NSString *)creatMD5value:(id)obj;

+ (void)updateVewsin:(BOOL)isBigVersion UpdateInfo:(NSString *)updateInfo;

@end
