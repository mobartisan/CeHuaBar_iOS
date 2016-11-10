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
@interface HomeVoteCell ()

@property (strong, nonatomic) UIImageView *iconImV;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIImageView *imageV1;
@property (strong, nonatomic) UILabel *projectLB;
@property (strong, nonatomic) UIImageView *imageV2;
@property (strong, nonatomic) VoteView *photoContainerView;
@property (strong, nonatomic) UILabel *aLB;
@property (strong, nonatomic) UILabel *bLB;
@property (strong, nonatomic) UILabel *cLB;
@property (strong, nonatomic) UIProgressView *aProgressView;
@property (strong, nonatomic) UIProgressView *bProgressView;
@property (strong, nonatomic) UIProgressView *cProgressView;
@property (strong, nonatomic) UILabel *aTicket;
@property (strong, nonatomic) UILabel *bTicket;
@property (strong, nonatomic) UILabel *cTicket;
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
    
    //图片
    self.photoContainerView = [VoteView new];
    [self.contentView addSubview:self.photoContainerView];
    
    //A
    self.aLB = [UILabel new];
    self.aLB.text = @"A";
    self.aLB.textColor = [UIColor whiteColor];
    self.aLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.aLB];
    
    self.aProgressView = [UIProgressView new];
    self.aProgressView.progressTintColor = kRGB(45, 198, 200);
    [self.contentView addSubview:self.aProgressView];
    
    self.aTicket = [UILabel new];
    self.aTicket.textAlignment = NSTextAlignmentLeft;
    self.aTicket.textColor = kRGB(105, 112, 120);
    self.aTicket.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.aTicket];
    
    //B
    self.bLB = [UILabel new];
    self.bLB.text = @"B";
    self.bLB.textColor = [UIColor whiteColor];
    self.bLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.bLB];
    
    self.bProgressView = [UIProgressView new];
    self.bProgressView.progressTintColor = kRGB(45, 198, 200);
    [self.contentView addSubview:self.bProgressView];
    
    self.bTicket = [UILabel new];
    self.bTicket.textAlignment = NSTextAlignmentLeft;
    self.bTicket.textColor = kRGB(105, 112, 120);
     self.bTicket.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.bTicket];
    
    //C
    self.cLB = [UILabel new];
    self.cLB.text = @"C";
    self.cLB.textColor = [UIColor whiteColor];
    self.cLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.cLB];
    
    self.cProgressView = [UIProgressView new];
    self.cProgressView.progressTintColor = kRGB(45, 198, 200);
    [self.contentView addSubview:self.cProgressView];
    
    self.cTicket = [UILabel new];
    self.cTicket.textAlignment = NSTextAlignmentLeft;
    self.cTicket.textColor = kRGB(105, 112, 120);
    self.cTicket.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.cTicket];
    
    
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
    
    self.photoContainerView.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.projectLB, 10);
    
    //A
    self.aLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.photoContainerView, 10).widthIs(10).heightIs(20);
    self.aTicket.sd_layout.rightSpaceToView(self.contentView, 17).centerYEqualToView(self.aLB).heightIs(20).widthIs(65);
    self.aProgressView.sd_layout.leftSpaceToView(self.aLB, 10).centerYEqualToView(self.aLB).rightSpaceToView(self.aTicket, 10).heightIs(4);
    
    //B
    self.bLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.aLB, 5).widthIs(10).heightIs(20);
    self.bTicket.sd_layout.rightSpaceToView(self.contentView, 17).centerYEqualToView(self.bLB).heightIs(20).widthIs(65);
    self.bProgressView.sd_layout.leftSpaceToView(self.bLB, 10).centerYEqualToView(self.bLB).rightSpaceToView(self.bTicket, 10).heightIs(4);
    
    //C
    self.cLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.bLB, 5).widthIs(10).heightIs(20);
    self.cTicket.sd_layout.rightSpaceToView(self.contentView, 17).centerYEqualToView(self.cLB).heightIs(20).widthIs(65);
    self.cProgressView.sd_layout.leftSpaceToView(self.cLB, 10).centerYEqualToView(self.cLB).rightSpaceToView(self.cTicket, 10).heightIs(4);
    
    //时间
    self.timeLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.cLB, 10).heightIs(20);
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
    self.aProgressView.progress = homeModel.aNum.floatValue / 10;
    self.bProgressView.progress = homeModel.bNum.floatValue / 10;
    self.cProgressView.progress = homeModel.cNum.floatValue / 10;
    self.aTicket.text = [NSString stringWithFormat:@"%@票(%0.f%%)", homeModel.aNum, homeModel.aNum.floatValue * 10];
    self.bTicket.text = [NSString stringWithFormat:@"%@票(%0.f%%)", homeModel.bNum, homeModel.bNum.floatValue * 10];
    self.cTicket.text = [NSString stringWithFormat:@"%@票(%0.f%%)", homeModel.cNum, homeModel.cNum.floatValue * 10];
    self.timeLB.text = homeModel.time;
}

@end
