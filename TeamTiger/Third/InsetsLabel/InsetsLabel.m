//
//  InsetsLabel.m
//  TeamTiger
//
//  Created by xxcao on 2017/1/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets
{
    if (self = [super initWithFrame:frame]) {
        _insets = insets;
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect,_insets)];
}

@end
