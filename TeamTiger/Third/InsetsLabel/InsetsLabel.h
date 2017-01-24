//
//  InsetsLabel.h
//  TeamTiger
//
//  Created by xxcao on 2017/1/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel

@property(nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;


@end
