//
//  NSString+Utils.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

+ (NSString *)iphoneOS_description;

+ (NSString *)randomStringWithLength:(int)len;

//文字自适应高度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
