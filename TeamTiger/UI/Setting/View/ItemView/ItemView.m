//
//  ItemView.m
//  TeamTiger
//
//  Created by xxcao on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView

- (instancetype)initWithData:(id)object {
    self = [super init];
    if (self) {
        TT_Project_Members *member = (TT_Project_Members *)object;
        _headImgV = [[UIImageView alloc] init];
        _headImgV.backgroundColor = [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0  blue:205.0 / 255.0  alpha:1.0];
        
        CGFloat itemSize = Screen_Width / 4.0;
        CGFloat headSize = itemSize - 18 * 2;
        setViewCorner(_headImgV, headSize / 2.0);
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(headSize));
            make.height.equalTo(@(headSize));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(@10);
        }];
        
        if (![Common isEmptyString:member.user_img_url]) {
           [_headImgV sd_setImageWithURL:[NSURL URLWithString:member.user_img_url] placeholderImage:kImage(@"1")];
        }
        
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:12];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor lightTextColor];
        [self addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@64);
            make.height.equalTo(@20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_headImgV.mas_bottom).offset(2);
        }];
        
        if (![Common isEmptyString:member.user_name]) {
            _nameLab.text = member.user_name;
        }
        
        
        if(!object) {
            //add icon
            _nameLab.hidden = YES;
            _headImgV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [_headImgV addGestureRecognizer:tapGR];
            _headImgV.image = [UIImage imageNamed:@"icon_add_member"];
            _headImgV.backgroundColor = [UIColor clearColor];
            _headImgV.contentMode = UIViewContentModeCenter;
        }
    }
    return self;
}

- (void)tapAction:(id)sender {
    if (self.didSelectBlock) {
        self.didSelectBlock(self);
    }
}

@end
