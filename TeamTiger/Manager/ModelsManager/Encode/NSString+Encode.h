//
//  NSString+Encode.h
//  Excel2Plist
//
//  Created by Minghu Hu on 11/12/21.
//  Copyright (c) 2011年 sf-sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Encode)


- (NSString *)encodedString;
- (NSString *)decodedString;

+ (NSString *)encodeString:(NSString *)stringToEncode;
+ (NSString *)decodeString:(NSString *)stringToDecode;

@end
