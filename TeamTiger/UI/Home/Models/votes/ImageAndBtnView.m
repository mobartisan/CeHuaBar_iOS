//
//  ImageAndBtnView.m
//  TeamTiger
//
//  Created by Dale on 16/11/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ImageAndBtnView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"

@interface ImageAndBtnView ()<SDPhotoBrowserDelegate>


@end
@implementation ImageAndBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.imageV = [UIImageView new];
    self.imageV.userInteractionEnabled = YES;
    self.imageV.image = kImage(@"image_1");
    [self addSubview:self.imageV];
    
    self.projectLB = [UILabel new];
    self.projectLB.text = @"A";
    self.projectLB.textColor = kRGB(46, 201, 202);
    self.projectLB.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.projectLB];
    
    self.voteBtn = [UIButton new];
    self.voteBtn.layer.borderColor = kRGB(46, 201, 202).CGColor;
    self.voteBtn.layer.borderWidth = 1;
    self.voteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    self.voteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.voteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.voteBtn setImage:kImage(@"icon_dislike") forState:UIControlStateNormal];
    [self addSubview:self.voteBtn];
    
    
    CGFloat maxWidth = 0.0;

    maxWidth = (kScreenWidth - 67 - 25 - 14) / 3;
    
    self.imageV.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(maxWidth).heightEqualToWidth();
    
    self.projectLB.sd_layout.leftSpaceToView(self, 2).topSpaceToView(self.imageV, 7).widthIs(15).heightIs(20);
    
    self.voteBtn.sd_layout.leftSpaceToView(self.projectLB, 2).topSpaceToView(self.imageV, 7).rightSpaceToView(self, 5).heightIs(20);
    
    [self setupAutoHeightWithBottomView:self.voteBtn bottomMargin:2];
}

@end
