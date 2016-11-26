//
//  HomeVoteCell.m
//  TeamTiger
//
//  Created by Dale on 16/11/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeVoteCell.h"
#import "HomeModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "VoteView.h"
#import "ButtonIndexPath.h"

@interface HomeVoteCell ()

@property (strong, nonatomic) UIImageView *iconImV;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIImageView *imageV1;
@property (strong, nonatomic) UILabel *projectLB;
@property (strong, nonatomic) UIImageView *imageV2;
@property (strong, nonatomic) ButtonIndexPath *projectBtn;
@property (strong, nonatomic) VoteView *photoContainerView;
@property (strong, nonatomic) VoteBottomView *voteBottomView;

@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) UIView *separLine;

@end

@implementation HomeVoteCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"HomeVoteCell";
    HomeVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HomeVoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kRGBColor(28, 37, 51);
        [self setupCellContentView];
    }
    return self;
}

- (void)setupCellContentView {
    //头像
    self.iconImV = [UIImageView new];
    self.iconImV.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.iconImV];
    
    //姓名
    self.nameLB = [UILabel new];
    self.nameLB.textColor = [Common colorFromHexRGB:@"446695"];
    self.nameLB.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.contentView addSubview:self.nameLB];
    
    self.imageV1 = [UIImageView new];
    self.imageV1.image = [UIImage imageNamed:@"＃"];
    [self.contentView addSubview:self.imageV1];
    
    //项目
    self.projectLB = [UILabel new];
    self.projectLB.textColor = [Common colorFromHexRGB:@"5093ef"];
    self.projectLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.projectLB];
    
    self.imageV2 = [UIImageView new];
    self.imageV2.image = [UIImage imageNamed:@"＃"];
    [self.contentView addSubview:self.imageV2];
    
    self.projectBtn = [ButtonIndexPath buttonWithType:UIButtonTypeCustom];
    [self.projectBtn addTarget:self action:@selector(handleClickProjectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.projectBtn];
    
    //图片
    self.photoContainerView = [[VoteView alloc] init];
    [self.contentView addSubview:self.photoContainerView];
    
    self.voteBottomView = [[VoteBottomView alloc] init];
    [self.contentView addSubview:self.voteBottomView];
    
    //时间
    self.timeLB = [UILabel new];
    self.timeLB.textColor = [Common colorFromHexRGB:@"6f839d"];
    self.timeLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLB];

    //分割线
    self.separLine = [UIView new];
    self.separLine.backgroundColor = kRGBColor(41, 50, 61);
    [self.contentView addSubview:self.separLine];
    
    self.iconImV.sd_layout.leftSpaceToView(self.contentView, 17).topSpaceToView(self.contentView, 19).widthIs(37).heightIs(37);
    self.iconImV.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    
    self.nameLB.sd_layout.leftSpaceToView(self.iconImV, 13).topSpaceToView(self.contentView, 20).widthIs(200).heightIs(17);
    [self.nameLB setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.imageV1.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.nameLB, 9).widthIs(8).heightIs(10);
    
    self.projectLB.sd_layout.leftSpaceToView(self.imageV1, 2).topSpaceToView(self.nameLB, 7).heightIs(13);
    [self.projectLB setSingleLineAutoResizeWithMaxWidth:80];
    
    
    self.imageV2.sd_layout.leftSpaceToView(self.projectLB, 2).topEqualToView(self.imageV1).widthIs(8).heightIs(10);
    
    self.projectBtn.sd_layout.leftEqualToView(self.imageV1).rightEqualToView(self.imageV2).topSpaceToView(self.nameLB, 7).heightIs(20);
    
    self.photoContainerView.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.projectLB, 10);
    
    self.voteBottomView.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.photoContainerView, 10);
    
    //时间
    self.timeLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.voteBottomView, 10).heightIs(20);
    [self.timeLB setSingleLineAutoResizeWithMaxWidth:200];
    [self.timeLB updateLayout];
    
    self.separLine.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1.5).topSpaceToView(self.timeLB, 10);
    
    [self setupAutoHeightWithBottomView:self.separLine bottomMargin:0];
}

- (void)setHomeModel:(HomeModel *)homeModel {
    _homeModel = homeModel;
    self.iconImV.image = [UIImage imageNamed:homeModel.iconImV];
    self.nameLB.text = homeModel.name;
    self.projectLB.text = homeModel.project;
    self.photoContainerView.picPathStringsArray = homeModel.photeNameArry;
    NSLog(@"%@", NSStringFromCGRect(self.photoContainerView.frame));
    self.voteBottomView.ticketArr = homeModel.ticketArry;
    self.timeLB.text = homeModel.time;
}


- (void)handleClickProjectBtnAction:(ButtonIndexPath *)sender {
    if ([self.delegate respondsToSelector:@selector(clickVoteProjectBtn:)]) {
        [self.delegate clickVoteProjectBtn:_homeModel.Id];
    }
}

@end
