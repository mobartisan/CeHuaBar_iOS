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

    setViewCorner(self.pointImg, 3.0);
    setViewCorner(self.pointImgV, 4.0);
    setViewCorner(self.msgNumBGImgV, 10);
    
    self.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast{
    if (object && [object isKindOfClass:[TT_Project class]]) {
        TT_Project *project = (TT_Project *)object;
        self.project = project;
        
        [self.pointImgV sd_setImageWithURL:[NSURL URLWithString:project.logoURL] placeholderImage:kImage(@"img_logo")];
        self.msgNumLab.text = @(arc4random()%99 + 1).stringValue;
        self.projectNameLab.text = project.name;
        NSLog(@"member_type:%zd", project.member_type);
        self.pointImg.backgroundColor = project.member_type == 1 ? kRGB(45, 202, 205) : kRGB(255, 128, 0);//1/绿色-我创建的  2/橙色-我加入的
        UIView *v = [self viewWithTag:2016 + self.tag];
        if (v && [v isKindOfClass:[UIImageView class]]) [v removeFromSuperview];
        if (!isLast) {
            UIImageView *line = [[UIImageView alloc] init];
            line.tag = 2016 + self.tag;
            [self addSubview:line];
            line.backgroundColor = [UIColor darkGrayColor];
            line.alpha = 0.618;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.pointImgV.mas_right).offset(8.0);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom).offset(-minLineWidth);
                make.height.mas_equalTo(minLineWidth);
            }];
        }
        self.arrowImgV.hidden = NO;
    
     

        
        self.notdisturbImgV.hidden = project.isNoDisturb ? NO : YES;
        self.msgNumLab.hidden = project.isNoDisturb;
        self.msgNumBGImgV.hidden = project.isNoDisturb;
    }
}


//子控件布局
- (void)layoutSubviews{
    self.containerView.frame = self.contentView.bounds;
}



@end
