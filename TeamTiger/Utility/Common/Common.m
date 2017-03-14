//
//  Common.m
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "Common.h"
#import "HYBHelperBlocksKit.h"
#import "JKEncrypt.h"

@interface Common()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end
@implementation Common

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM月dd日"];
        
    }
    return _dateFormatter;
}

//去除UITableView多余分割线
+ (void)removeExtraCellLines:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.opaque = NO;
    [tableView setTableFooterView:view];
}

//字符串为空检查
+ (BOOL)isEmptyString:(NSString *)sourceStr {
    if ((NSNull *)sourceStr == [NSNull null]) {
        return YES;
    }
    if (sourceStr == nil) {
        return YES;
    }
    if (sourceStr == NULL) {
        return YES;
    }
    if ([sourceStr isEqual:[NSNull null]]) {
        return YES;
    }
    if (![sourceStr isKindOfClass:[NSString class]]) {
        return YES;
    }
    if([sourceStr isEqualToString:@"<null>"]){
        return YES;
    }
    if ([sourceStr isEqualToString:@"null"]) {
        return YES;
    }
    if ([sourceStr isEqualToString:@""]) {
        return YES;
    }
    if (sourceStr.length == 0) {
        return YES;
    }
    return NO;
}

//数组是否为空
+ (BOOL)isEmptyArr:(NSArray *)arr {
    if ( arr != nil && ![arr isKindOfClass:[NSNull class]] && arr.count != 0) {
        return NO;
    }
    return YES;
}

//获取安全的字符串
+ (NSString *)safeString:(NSString *)sourceStr {
    if([Common isEmptyString:sourceStr]){
        return @"";
    }
    return sourceStr;
}

//处理微信头像 头像大小 46 64 96 132
+ (NSString *)handleWeChatHeadImageUrl:(NSString *)headImgUrl Size:(double)size {
    if (![Common isEmptyString:headImgUrl]) {
        NSString *urlString = headImgUrl;
        NSMutableString *mString = [NSMutableString string];
        if ([urlString containsString:@".jpg"] || [urlString containsString:@".png"]) {
            mString = urlString.mutableCopy;
        } else {
            NSArray *components = [urlString componentsSeparatedByString:@"/"];
            NSInteger count = components.count;
            [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != count - 1) {
                    [mString appendFormat:@"%@/",obj];
                } else {
                    [mString appendFormat:@"%d",(int)size];//头像大小 46 64 96 132
                }
            }];
        }
        return mString;
    }
    return nil;
}


//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc Type:(NSString *)animationType SubType:(NSString *)subType{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = animationType;
    transition.subtype = subType;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav pushViewController:vc animated:NO];
}

//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav Type:(NSString *)animationType SubType:(NSString *)subType{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = animationType;
    transition.subtype = subType;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav popViewControllerAnimated:NO];
}

/*
 animation.type = kCATransitionFade;
 animation.type = kCATransitionPush;
 animation.type = kCATransitionReveal;
 animation.type = kCATransitionMoveIn;
 animation.type = @"cube";
 animation.type = @"suckEffect";
 animation.type = @"oglFlip";
 animation.type = @"rippleEffect";
 animation.type = @"pageCurl";
 animation.type = @"pageUnCurl";
 animation.type = @"cameraIrisHollowOpen";
 animation.type = @"cameraIrisHollowClose";
 
 
 CA_EXTERN NSString * const kCATransitionFromRight
 __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
 CA_EXTERN NSString * const kCATransitionFromLeft
 __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
 CA_EXTERN NSString * const kCATransitionFromTop
 __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
 CA_EXTERN NSString * const kCATransitionFromBottom
 __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);

 */

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (![Common isEmptyString:inColorString]) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha: 1.0];
    return result;
}

//返回系统年月日时间 YYYY-MM-DD
+ (NSString *)getCurrentSystemYearMonthDay {
    return [NSString stringWithFormat:@"%02tu-%02tu-%02tu", [[NSDate date] hyb_year], [[NSDate date] hyb_month], [[NSDate date] hyb_day]];
}

//返回系统时间
+ (NSString *)getCurrentSystemTime {
    return [NSString stringWithFormat:@"%02tu月%02tu日 %02tu:%02tu", [[NSDate date] hyb_month], [[NSDate date] hyb_day], [[NSDate date] hyb_hour], [[NSDate date] hyb_minute]];
}

//系统日期
+ (NSString *)getCurrentSystemDate {
    return [NSString stringWithFormat:@"%02tu月%02tu日", [[NSDate date] hyb_month], [[NSDate date] hyb_day]];
}

//返回系统月日 时分秒
+ (NSString *)getCurrentSystemMonthDayHourMinuteSecond {
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%02tu月%02tu日 %02tu:%02tu:%02tu", [date hyb_month], [date hyb_day],[date hyb_hour],[date hyb_minute],[date hyb_second]];
}

//处理时间
+ (NSString *)handleDate:(NSString *)dateStr {
    NSDate *date = [NSDate hyb_dateWithString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"%02tu月%02tu日 %02tu:%02tu", [date hyb_month], [date hyb_day],[date hyb_hour],[date hyb_minute]];
}

+ (NSString *)handleDateMonthDayHourMinuteSecond:(NSString *)dateStr {
    NSDate *date = [NSDate hyb_dateWithString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"%02tu月%02tu日 %02tu:%02tu:%02tu", [date hyb_month], [date hyb_day],[date hyb_hour],[date hyb_minute],[date hyb_second]];
}

+ (NSString *)handleDateMonthDayHourMinute:(NSString *)dateStr {
    NSDate *date = [NSDate hyb_dateWithString:dateStr format:@"MM月dd日 HH:mm:ss"];
    return [NSString stringWithFormat:@"%02tu月%02tu日 %02tu:%02tu", [date hyb_month], [date hyb_day],[date hyb_hour],[date hyb_minute]];
}

//比较时间大小
+ (NSDateComponents *)differencewithDate:(NSString *)dateString withDate:(NSString *)anotherdateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *createDate = [dateFormatter dateFromString:dateString];
    NSDate *now = [dateFormatter dateFromString:anotherdateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    return cmps;
}

//生成BarItem
+ (UIBarButtonItem *)createBarItemWithTitle:(NSString *)name
                                     Nimage:(UIImage *)nImg
                                     Himage:(UIImage *)hImg
                                       Size:(CGSize)size
                                   Selector:(void (^)())block {
    UIButton *btn = [UIButton hyb_buttonWithTouchUp:^(UIButton *sender) {
        block();
    }];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn setBackgroundImage:nImg
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:hImg
                   forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}


+ (UIBarButtonItem *)createBackBarButton:(NSString *)name
                                Selector:(void(^)())block {
    UIButton *btn = [UIButton hyb_buttonWithTouchUp:^(UIButton *sender) {
        block();
    }];
    btn.frame = CGRectMake(0, 0, 22, 22);
    [btn setImage:[UIImage imageNamed:@"icon_back"]
         forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back"]
         forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

//对字典加密 返回 key=value&key1=value2
+ (NSString *)encyptWithDictionary:(NSDictionary *)srcDic UnencyptKeys:(NSArray *)keys {
    NSMutableString *mString = [NSMutableString string];
    JKEncrypt *jkEncrypt = [[JKEncrypt alloc] init];
    [srcDic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tmpStr = nil;
        if ([keys containsObject:key]) {
            tmpStr = [NSString stringWithFormat:@"%@=%@", key, obj];
        } else {
            tmpStr = [NSString stringWithFormat:@"%@=%@", key, [jkEncrypt doEncryptHex:obj]];
        }
        [mString appendFormat:@"%@&",tmpStr];
    }];
    [mString replaceCharactersInRange:NSMakeRange(mString.length - 1, 1) withString:@""];
    return mString;
}

+ (NSDictionary *)unEncyptWithString:(NSString *)srcStr {
    NSArray *array = [srcStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *keyValues = [obj componentsSeparatedByString:@"="];
        if (keyValues.count == 2) {
            mDic[keyValues[0]] = keyValues[1];
        }
    }];
    return mDic;
}

@end
