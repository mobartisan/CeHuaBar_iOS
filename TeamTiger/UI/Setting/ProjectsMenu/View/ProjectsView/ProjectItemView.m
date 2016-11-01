//
//  ProjectItemView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectItemView.h"
#import "UIButton+HYBHelperBlockKit.h"

@interface ProjectItemView ()

@property(nonatomic,strong) UILabel *projectNameLabel;

@property(nonatomic,strong) UILabel *msgLabel;

@property(nonatomic,strong) UIImageView *unreadMsgImgV;

@property(nonatomic,strong) UIButton *addBtn;

@end

@implementation ProjectItemView

- (instancetype)initWithData:(id)object {
    self = [super init];
    if (self) {
        self.backgroundColor = ColorRGB(25.0, 34.0, 49.0);
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            self.msgLabel.text = @"12";
            if (self.msgLabel.text.integerValue > 0) {
                self.unreadMsgImgV.hidden = NO;
            } else {
                self.unreadMsgImgV.hidden = YES;
            }
            self.projectNameLabel.text = object[@"Name"];
        }
        self.addBtn = [UIButton hyb_buttonWithImage:nil superView:self constraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        } touchUp:^(UIButton *sender) {
            if (!object) {
                //add
                if (self.clickAddProjectItemBlock) {
                    self.clickAddProjectItemBlock(self);
                }
            } else {
                //look up
                if (self.clickProjectItemBlock) {
                    self.clickProjectItemBlock(self, object);
                }
            }
        }];
        if (!object) {
            [self.addBtn setImage:[UIImage imageNamed:@"icon_add_group"] forState:UIControlStateNormal];
        }
    }
    return self;
}

#pragma -mark getter
- (UILabel *)projectNameLabel {
    if (!_projectNameLabel) {
        _projectNameLabel = [[UILabel alloc] init];
        [self addSubview:_projectNameLabel];
        [_projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(50);
            make.width.equalTo(self.mas_width);
        }];
        _projectNameLabel.textColor = ColorRGB(252.0, 252.0, 252.0);
        _projectNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _projectNameLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        [self addSubview:_msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(50);
        }];
        _msgLabel.textColor = ColorRGB(41.0, 50.0, 63.0);
        _msgLabel.textAlignment = NSTextAlignmentRight;
        _msgLabel.font = [UIFont systemFontOfSize:50];
    }
    return _msgLabel;
}

- (UIImageView *)unreadMsgImgV {
    if (!_unreadMsgImgV) {
        _unreadMsgImgV = [[UIImageView alloc] init];
        _unreadMsgImgV.backgroundColor = ColorRGB(251, 11, 62);
        [self addSubview:_unreadMsgImgV];
        [_unreadMsgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        setViewCorner(_unreadMsgImgV, 6);
    }
    return _unreadMsgImgV;
}

@end
