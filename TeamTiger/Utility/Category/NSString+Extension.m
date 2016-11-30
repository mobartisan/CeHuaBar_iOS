//
//  NSString+Extension.m
//  TeamTiger
//
//  Created by Dale on 16/11/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
