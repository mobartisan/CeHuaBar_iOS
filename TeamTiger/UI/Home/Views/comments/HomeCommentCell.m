//
//  HomeCommentCell.m
//  BBSDemo
//
//  Created by Dale on 16/10/31.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeCommentCell.h"
#import "UIView+SDAutoLayout.h"
#import "HomeModel.h"
#import "HomeCommentModel.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HomeCommentModelFrame.h"

#define KLineH  10
#define KImageVH 15

@interface HomeCommentCell ()

@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UILabel *name1LB;
@property (strong, nonatomic) UILabel *desLB;
@property (strong, nonatomic) SDWeiXinPhotoContainerView *photoContainerView;
@property (strong, nonatomic) UIButton *moreBtn;

@end

@implementation HomeCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"cellId";
    HomeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HomeCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCellContentView];
    }
    return self;
}

- (void)setupCellContentView {
    
    //时间线
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [Common colorFromHexRGB:@"1b283a"];
    [self.contentView addSubview:self.lineView];
    
    self.lineView1 = [UIView new];
    self.lineView1.backgroundColor = [Common colorFromHexRGB:@"1b283a"];
    [self.contentView addSubview:self.lineView1];
    
    //亮点
    self.imageV = [UIImageView new];
    self.imageV.image = [UIImage imageNamed:@"img_point"];
    [self.contentView addSubview:self.imageV];
    
    //时间
    self.timeLB = [UILabel new];
    self.timeLB.textColor = [Common colorFromHexRGB:@"506075"];
    self.timeLB.font = [UIFont systemFontOfSize:12];
    self.timeLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLB];
    
    //姓名
    self.nameLB = [UILabel new];
    [self.contentView addSubview:self.nameLB];
    
    self.name1LB = [UILabel new];
    self.name1LB.textColor = [Common colorFromHexRGB:@"5093ef"];
    self.name1LB.font = KNameFont;
    [self.contentView addSubview:self.name1LB];
    
    //内容
    self.desLB = [UILabel new];
    self.desLB.numberOfLines = 0;
    self.desLB.textColor = [Common colorFromHexRGB:@"a8aaad"];
    self.desLB.font = KTextFont;
    [self.contentView addSubview:self.desLB];
    
    //图片
    self.photoContainerView = [SDWeiXinPhotoContainerView new];
    self.photoContainerView.isCommentCell = YES;
    [self.contentView addSubview:self.photoContainerView];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(clickMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.moreBtn];
    
}

- (void)clickMoreBtnAction {
    if ([self.delegate respondsToSelector:@selector(clickMoreBtn)]) {
        [self.delegate clickMoreBtn];
    }
}

- (void)setModelFrame:(HomeCommentModelFrame *)modelFrame {
    _modelFrame = modelFrame;
    [self settingData:modelFrame.homeCommentModel];
    [self settingFrame:modelFrame.homeCommentModel];
    
}

/**
 *  设置数据
 */
- (void)settingData:(HomeCommentModel *)homeCommentModel {
    if (![Common isEmptyString:homeCommentModel.time]) {
        self.timeLB.text = [[homeCommentModel.time componentsSeparatedByString:@" "] lastObject];
    }
    self.imageV.image = homeCommentModel.open ? kImage(@"img_point_normal") : kImage(@"img_point");
    if ([homeCommentModel.sName isEqualToString:@"时间节点"]) {
        self.nameLB.backgroundColor = [Common colorFromHexRGB:@"151f2c"];
        self.nameLB.textColor = [Common colorFromHexRGB:@"69737f"];
        self.nameLB.layer.cornerRadius = 3;
        self.nameLB.layer.masksToBounds = YES;
        self.nameLB.font = KTimeFont;
        self.name1LB.hidden = YES;
    }else {
        self.nameLB.backgroundColor = kRGBColor(32, 46, 63);
        self.nameLB.textColor = [Common colorFromHexRGB:@"ffffff"];
        self.nameLB.font = KNameFont;
        self.name1LB.hidden = NO;
    }
    self.nameLB.text = homeCommentModel.name;
    self.name1LB.text = homeCommentModel.sName;
    self.desLB.text = homeCommentModel.content;
    self.photoContainerView.picPathStringsArray = homeCommentModel.photeNameArry;
    self.photoContainerView.content = homeCommentModel.content;
}

/**
 *  设置frame
 */
- (void)settingFrame:(HomeCommentModel *)homeCommentModel {

    self.lineView.frame = self.modelFrame.lineF;
    
    self.lineView1.frame = self.modelFrame.line1F;
    
    self.imageV.frame = self.modelFrame.imageF;
    
    self.timeLB.frame = self.modelFrame.timeF;
    
    self.nameLB.frame = self.modelFrame.nameF;
    
    self.name1LB.frame = self.modelFrame.name1F;
    
    if (![Common isEmptyString:homeCommentModel.content]) {
        self.desLB.frame = self.modelFrame.contentF;
    }
    if (homeCommentModel.photeNameArry != nil && ![homeCommentModel.photeNameArry isKindOfClass:[NSNull class]] && homeCommentModel.photeNameArry.count != 0) {// 有配图
        self.photoContainerView.hidden = NO;
        self.photoContainerView.frame = self.modelFrame.pictureF;
    }else {
        self.photoContainerView.hidden = YES;
    }

    if (_modelFrame.homeCommentModel.show) {
        self.moreBtn.hidden = NO;
        self.moreBtn.frame = self.modelFrame.moreBtnF;
        self.lineView1.hidden = YES;
    }else {
        self.moreBtn.hidden = YES;
        self.lineView1.hidden = NO;
    }
    
}
@end
