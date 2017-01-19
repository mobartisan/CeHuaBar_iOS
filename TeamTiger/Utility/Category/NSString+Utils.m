//
//  NSString+Utils.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "NSString+Utils.h"
#import <sys/utsname.h>

@implementation NSString (Utils)

//汉字的拼音
- (NSString *)pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [[[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] substringToIndex:1];
}


+ (NSString *)iphoneOS_description {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
//    
//    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
//    
//    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
//    
//    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
//    
//    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
//    
//    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
//    
//    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
//    
//    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
//    
//    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
//    
//    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
//    
//    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
//    
//    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
//    
//    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//    
//    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
//    
//    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
//    
//    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
//    
//    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
//    
//    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
//    
//    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
//    
//    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
//    
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//    
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}


+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
