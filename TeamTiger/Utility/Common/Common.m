//
//  Common.m
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "Common.h"
#import "HYBHelperBlocksKit.h"

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
    homeCommentModel.photeNameArry != nil && ![homeCommentModel.photeNameArry isKindOfClass:[NSNull class]] && homeCommentModel.photeNameArry.count != 0
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

//返回系统时间
+ (NSString *)getCurrentSystemTime {
    return [NSString stringWithFormat:@"%ld月%ld日 %ld:%ld", [[NSDate date] hyb_month], [[NSDate date] hyb_day], [[NSDate date] hyb_hour], [[NSDate date] hyb_minute]];
}

//系统日期
+ (NSString *)getCurrentSystemDate {
    return [NSString stringWithFormat:@"%ld月%ld日", [[NSDate date] hyb_month], [[NSDate date] hyb_day]];
}

//比较时间大小
- (NSDateComponents *)differencewithDate:(NSString *)dateString withDate:(NSString *)anotherdateString {
    NSDate *createDate = [self.dateFormatter dateFromString:dateString];
    NSDate *now = [self.dateFormatter dateFromString:anotherdateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
//    NSLog(@"%@ %@ %@", createDate, now, cmps);
    
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

@end
