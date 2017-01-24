//
//  Extension.m
//  TeamTiger
//
//  Created by xxcao on 2017/1/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)


- (void)beyondMaxLength:(NSInteger)maxLength BeyondBlock:(MaxLengthBlock)block {
    NSString *text = self.text;
    //    NSLog(@"text:%@",text);
    
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
    
    if (!position){
        //---字节处理
        //Limit
        NSUInteger textBytesLength = [self.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (textBytesLength > maxLength) {
            block(YES);
            NSRange range;
            NSUInteger byteLength = 0;
            for(int i = 0; i < text.length && byteLength <= maxLength; i += range.length) {
                range = [self.text rangeOfComposedCharacterSequenceAtIndex:i];
                byteLength += strlen([[text substringWithRange:range] UTF8String]);
                if (byteLength > maxLength) {
                    NSString* newText = [text substringWithRange:NSMakeRange(0, range.location)];
                    self.text = newText;
                }
            }
        }
    }
}

@end
