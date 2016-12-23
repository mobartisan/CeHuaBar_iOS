//
//  ProjectItemView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectItemView.h"

@interface ProjectItemView ()

@property(nonatomic,strong) UILabel *projectNameLabel;

@property(nonatomic,strong) UILabel *msgLabel;

@property(nonatomic,strong) UIImageView *unreadMsgImgV;

@property(nonatomic,strong) UIButton *addBtn;

@property(nonatomic,strong) id tmpObj;

@end

@implementation ProjectItemView

- (instancetype)initWithData:(id)object  {
    self = [super init];
    if (self) {
        self.backgroundColor = [Common colorFromHexRGB:@"202e41"];
        if (object && [object isKindOfClass:[TT_Group class]]) {
            TT_Group *group = (TT_Group *)object;
            self.msgLabel.text = @(arc4random() % 10).stringValue;
            if (self.msgLabel.text.integerValue > 0) {
                self.unreadMsgImgV.hidden = NO;
            } else {
                self.unreadMsgImgV.hidden = YES;
            }
            self.projectNameLabel.text = group.group_name;
            self.unreadMsgImgV.backgroundColor = ColorRGB(arc4random() % 256, arc4random() % 256, arc4random() % 256);
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
        else {
            //添加长按
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)];
            longPress.minimumPressDuration = 0.8; //定义按的时间
            [self.addBtn addGestureRecognizer:longPress];
            self.tmpObj = object;//传值用
        }
    }
    return self;
}

- (void)longPressItem:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            //long press
            if (self.longPressItemBlock) {
                self.longPressItemBlock(self, self.tmpObj);
            }
        }];
    }
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
        _projectNameLabel.textColor = [Common colorFromHexRGB:@"ffffff"];
        _projectNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _projectNameLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        [self addSubview:_msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0).offset(3);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).offset(-20);
        }];
        _msgLabel.textColor = [Common colorFromHexRGB:@"2e3a4a"];
        _msgLabel.textAlignment = NSTextAlignmentRight;
        _msgLabel.font = [UIFont boldSystemFontOfSize:75];
    }
    return _msgLabel;
}

- (UIImageView *)unreadMsgImgV {
    if (!_unreadMsgImgV) {
        _unreadMsgImgV = [[UIImageView alloc] init];
        [self addSubview:_unreadMsgImgV];
        [_unreadMsgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(10);
        }];
        setViewCorner(_unreadMsgImgV, 5);
    }
    return _unreadMsgImgV;
}

@end
