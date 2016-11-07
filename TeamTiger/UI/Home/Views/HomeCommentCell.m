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
    self.nameLB.textColor = [Common colorFromHexRGB:@"ffffff"];
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLB];
    
    self.name1LB = [UILabel new];
    self.name1LB.textColor = [Common colorFromHexRGB:@"5093ef"];
    self.name1LB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.name1LB];
    
    //内容
    self.desLB = [UILabel new];
    self.desLB.textColor = [Common colorFromHexRGB:@"a8aaad"];
    self.desLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.desLB];
    
    //图片
    self.photoContainerView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:self.photoContainerView];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.hidden = YES;
    [self.moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(clickMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.moreBtn];
    
    
    self.lineView.sd_layout.leftSpaceToView(self.contentView, 61).topSpaceToView(self.contentView, 0).widthIs(4).heightIs(KLineH);
    
    self.lineView1.sd_layout.centerXEqualToView(self.lineView).topSpaceToView(self.lineView, 0).widthIs(4);
    
    self.imageV.sd_layout.centerXEqualToView(self.lineView).topSpaceToView(self.lineView, - KImageVH / 2).widthIs(KImageVH).heightIs(KImageVH);
    
    self.timeLB.sd_layout.leftSpaceToView(self.contentView, 8).centerYEqualToView(self.imageV).widthIs(38).heightIs(20);
    
    
    self.nameLB.sd_layout.leftSpaceToView(self.contentView, 78).centerYEqualToView(self.imageV).heightIs( 20);
    [self.nameLB setSingleLineAutoResizeWithMaxWidth:80];
    
    self.name1LB.sd_layout.leftSpaceToView(self.nameLB, 2).centerYEqualToView(self.imageV).heightIs(10);
    [self.name1LB setSingleLineAutoResizeWithMaxWidth:80];
    
    self.desLB.sd_layout.leftEqualToView(self.nameLB).rightSpaceToView(self.contentView, 10).topSpaceToView(self.nameLB, 5).autoHeightRatio(0);
    
    self.photoContainerView.sd_layout.leftEqualToView(self.nameLB);
    
    self.moreBtn.sd_layout.rightSpaceToView(self.contentView, 15).bottomSpaceToView(self.contentView, 5).widthIs(30).heightIs(30);
}

- (void)setHomeCommentModel:(HomeCommentModel *)homeCommentModel {
    _homeCommentModel = homeCommentModel;
    
    if ([homeCommentModel.time isEqualToString:@"这是时间节点"]) {
        self.timeLB.text = @"昨天";
        self.nameLB.backgroundColor = [Common colorFromHexRGB:@"151f2c"];
        self.nameLB.font = [UIFont systemFontOfSize:12];
        self.nameLB.textColor = [Common colorFromHexRGB:@"69737f"];
    }else {
        self.timeLB.text = [homeCommentModel.time substringFromIndex:5];
    }
    self.nameLB.text = homeCommentModel.name;
    self.name1LB.text = homeCommentModel.sName;
    self.desLB.text = homeCommentModel.content;
    _photoContainerView.picPathStringsArray = homeCommentModel.photeNameArry;
    
    CGFloat height = 0;
    if (homeCommentModel.photeNameArry != nil && ![homeCommentModel.photeNameArry isKindOfClass:[NSNull class]] && homeCommentModel.photeNameArry.count != 0) {
        self.photoContainerView.sd_layout.topSpaceToView(self.desLB, 5);
        [self.photoContainerView updateLayout];
        height = CGRectGetMaxY(self.photoContainerView.frame) ;
    } else {
        self.photoContainerView.sd_layout.topSpaceToView(self.desLB, 0);
        //主动刷新布局,获取desLb的frame
        [self.desLB updateLayout];
        height = CGRectGetMaxY(self.desLB.frame);
    }
    self.lineView1.sd_layout.heightIs(height);
    [self setupAutoHeightWithBottomView:self.lineView1 bottomMargin:0];
    
    
    if (homeCommentModel.show) {
        self.moreBtn.hidden = NO;
        self.lineView1.hidden = YES;
    }
    else {
        self.moreBtn.hidden = YES;
        self.lineView1.hidden = NO;
    }
    if (_homeCommentModel.open) {
        self.imageV.image = kImage(@"img_point_normal");
    }else {
        self.imageV.image = kImage(@"img_point");
    }
    
}

- (void)clickMoreBtnAction {
    if ([self.delegate respondsToSelector:@selector(clickMoreBtn)]) {
        [self.delegate clickMoreBtn];
    }
}

@end
