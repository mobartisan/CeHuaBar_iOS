//
//  InsetsLabel.m
//  TeamTiger
//
//  Created by xxcao on 2017/1/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    if (self = [super initWithFrame:frame]) {
        _insets = insets;
        _verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect1 = UIEdgeInsetsInsetRect(rect,_insets);
    CGRect actualRect2 = [self textRectForBounds:actualRect1
                          limitedToNumberOfLines:self.numberOfLines];
    return [super drawTextInRect:actualRect2];
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

@end
