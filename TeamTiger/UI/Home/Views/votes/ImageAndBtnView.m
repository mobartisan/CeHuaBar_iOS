//
//  ImageAndBtnView.m
//  TeamTiger
//
//  Created by Dale on 16/11/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ImageAndBtnView.h"
#import "UIView+SDAutoLayout.h"

@implementation ImageAndBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    CGFloat maxWidth = 0.0, margin = 0.0;
    if (is40inch || is47inch) {
        margin = 5;
        maxWidth = (kScreenWidth - 67 - 25 - 14) / 3;
    }else {
        margin = 10;
        maxWidth = 103;
    }
    
    self.imageV = [UIImageView new];
    self.imageV.userInteractionEnabled = YES;
    self.imageV.image = kImage(@"image_1");
    [self addSubview:self.imageV];
    
    self.projectLB = [UILabel new];
    self.projectLB.text = @"A";
    self.projectLB.textColor = kRGB(46, 201, 202);
    self.projectLB.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.projectLB];
    
    self.voteBtn = [ButtonIndexPath new];
    self.voteBtn.layer.borderColor = kRGB(46, 201, 202).CGColor;
    self.voteBtn.layer.borderWidth = 1;
    self.voteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    self.voteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -margin);
    self.voteBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -5, 0, 0);
    [self addSubview:self.voteBtn];
    
    
    self.imageV.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(maxWidth).heightEqualToWidth();
    
    self.projectLB.sd_layout.leftSpaceToView(self, 2).topSpaceToView(self.imageV, 7).widthIs(15).heightIs(20);
    
    self.voteBtn.sd_layout.leftSpaceToView(self.projectLB, 0).topSpaceToView(self.imageV, 7).rightSpaceToView(self, 5).heightIs(20);
    
    [self setupAutoHeightWithBottomView:self.voteBtn bottomMargin:2];
    
}

@end

@implementation ProgresssAndTicketView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.aLB = [UILabel new];
    self.aLB.textColor = [UIColor whiteColor];
    self.aLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.aLB];
    
    self.aTicket = [UILabel new];
    self.aTicket.textAlignment = NSTextAlignmentLeft;
    self.aTicket.textColor = kRGB(105, 112, 120);
    self.aTicket.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.aTicket];
    
    self.aProgressView = [UIProgressView new];
    self.aProgressView.progressTintColor = kRGB(45, 198, 200);
    [self addSubview:self.aProgressView];
    
    self.aLB.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(12).heightIs(20);
    
    self.aTicket.sd_layout.rightSpaceToView(self, 0).centerYEqualToView(self.aLB).heightIs(20).widthIs(65);
    
    self.aProgressView.sd_layout.leftSpaceToView(self.aLB, 10).centerYEqualToView(self.aLB).rightSpaceToView(self.aTicket, 10).heightIs(4);
    
    [self setupAutoHeightWithBottomView:self.aLB bottomMargin:0];
}

@end
