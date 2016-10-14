//
//  ProjectCell.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectsCell.h"

@implementation ProjectsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.pointImgV, 7.5);
    setViewCorner(self.msgNumBGImgV, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast{
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        self.pointImgV.backgroundColor = ColorRGB(arc4random() % 256, arc4random() % 256, arc4random() % 256);
        self.msgNumLab.text = @(arc4random()%99 + 1).stringValue;
        self.projectNameLab.text = object[@"Name"];

        UIView *v = [self viewWithTag:2016 + self.tag];
        if (v && [v isKindOfClass:[UIImageView class]]) [v removeFromSuperview];
        if (!isLast) {
            UIImageView *line = [[UIImageView alloc] init];
            line.tag = 2016 + self.tag;
            [self addSubview:line];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.3;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(44.0);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom).offset(-1);
                make.height.mas_equalTo(minLineWidth);
            }];
        }
    }
}

@end
