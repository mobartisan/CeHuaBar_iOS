//
//  HomeCell.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeCell.h"
#import "UITextView+Placeholder.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HomeModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "HomeCommentCell.h"
#import "ButtonIndexPath.h"
#import "TableViewIndexPath.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"

#define KHeaderViewH  10

@interface HomeCell ()<UITableViewDataSource, UITableViewDelegate, HomeCommentCellDelegate>

@property (strong, nonatomic) UIImageView *iconImV;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIImageView *imageV1;
@property (strong, nonatomic) UILabel *projectLB;
@property (strong, nonatomic) UIImageView *imageV2;
@property (strong, nonatomic) ButtonIndexPath *projectBtn;
@property (strong, nonatomic) UILabel *contentLB;
@property (strong, nonatomic) SDWeiXinPhotoContainerView *photoContainerView;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) UIView *separLine;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) HomeCommentModel *commentModel;

@end

@implementation HomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    //内容
    self.contentLB = [UILabel new];
    self.contentLB.textColor = [Common colorFromHexRGB:@"ffffff"];
    self.contentLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.contentLB];
    
    //图片
    self.photoContainerView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:self.photoContainerView];
    
    //时间
    self.timeLB = [UILabel new];
    self.timeLB.textColor = [Common colorFromHexRGB:@"6f839d"];
    self.timeLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLB];
    
    
    //评论按钮
    self.commentBtn = [ButtonIndexPath new];
    [self.commentBtn setImage:[UIImage imageNamed:@"icon_discussion"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"4" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[Common colorFromHexRGB:@"6f839d"] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.commentBtn addTarget:self action:@selector(handleCommentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.commentBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    [self.contentView addSubview:self.commentBtn];
    
    //讨论列表
    self.tableView = [[TableViewIndexPath alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kRGBColor(32, 46, 63);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = self.headerView;
    [Common removeExtraCellLines:self.tableView];
    [self.contentView addSubview:self.tableView];
    
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
    
    self.contentLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.imageV1, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    [self.contentLB setMaxNumberOfLinesToShow:6];
    
    self.photoContainerView.sd_layout.leftEqualToView(self.nameLB);
    
    
    self.timeLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.photoContainerView, 10).heightIs(20);
    [self.timeLB setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.commentBtn.sd_layout.centerYEqualToView(self.timeLB).rightSpaceToView(self.contentView, 18).widthIs(80).heightRatioToView(self.timeLB, 1);
    
    
    self.tableView.sd_layout.leftSpaceToView(self.contentView, 14).topSpaceToView(self.timeLB, 13).rightSpaceToView(self.contentView, 14);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    self.separLine.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1.5);
}

- (void)handleClickProjectBtnAction:(ButtonIndexPath *)sender {
    if ([self.delegate respondsToSelector:@selector(clickProjectBtn:)]) {
        [self.delegate clickProjectBtn:_homeModel.Id];
    }
}

- (void)handleCommentBtnAction:(ButtonIndexPath *)sender {
    _homeModel.open = !_homeModel.open;
    if (_homeModel.open) {
        _homeModel.indexModel.homeCommentModel.show = YES;
    }else {
        for (HomeCommentModelFrame *commentModelF in _homeModel.comment) {
            commentModelF.homeCommentModel.open = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(clickCommentBtn:)]) {
        [self.delegate clickCommentBtn:sender.indexPath];
    }
    
}


- (void)handleTapTableViewAction:(UIGestureRecognizer *)tap {
    [self.tableView endEditing:YES];
}


- (void)setHomeModel:(HomeModel *)homeModel {
    bgView = self.headerView;
    _homeModel = homeModel;
    [self.tableView reloadData];
    
    self.iconImV.image = [UIImage imageNamed:homeModel.iconImV];
    self.nameLB.text = homeModel.name;
    self.projectLB.text = homeModel.project;
    self.contentLB.text = homeModel.content;
    self.timeLB.text = homeModel.time;
    [self.commentBtn setTitle:homeModel.count forState:UIControlStateNormal];
    self.photoContainerView.picPathStringsArray = homeModel.photeNameArry;
    self.photoContainerView.content = homeModel.content;
    
    //图片
    if (homeModel.photeNameArry.count > 0) {
        _photoContainerView.sd_layout.topSpaceToView(self.contentLB,10);
    } else {
        _photoContainerView.sd_layout.topSpaceToView(self.contentLB,0);
    }
    if (_homeModel.open) {
        if (_homeModel.indexModel.homeCommentModel.show) {
            self.tableView.sd_layout.heightIs(homeModel.partHeight + KHeaderViewH + 45);
        }else {
            self.tableView.sd_layout.heightIs(homeModel.totalHeight + KHeaderViewH + 45);
        }
        self.separLine.sd_layout.topSpaceToView(self.tableView, 10);
    }else {
        self.tableView.sd_layout.heightIs(0);
        self.separLine.sd_layout.topSpaceToView(self.timeLB, 10);
    }
    [self setupAutoHeightWithBottomView:self.separLine bottomMargin:0];
    
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor = kRGBColor(27, 37, 50);
        
        //箭头视图
        UIImageView *iconI = [UIImageView new];
        iconI.image = [UIImage imageNamed:@"bg_discussion"];
        [_headerView addSubview:iconI];
        
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = kRGBColor(32, 46, 63);
        [_headerView addSubview:bgView];
        
        //输入视图
        UIImageView *inputImageV = [UIImageView new];
        inputImageV.image = kImage(@"icon_write");
        [bgView addSubview:inputImageV];
        
        //时间线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [Common colorFromHexRGB:@"1b283a"];
        [bgView addSubview:lineView];
        
        //亮点
        UIImageView *imageV = [UIImageView new];
        imageV.image = kImage(@"img_point");
        [bgView addSubview:imageV];
        
        UITextView *textView= [[UITextView alloc] init];
        textView.returnKeyType = UIReturnKeyDone;
        textView.placeholder = @" 讨论:";
        textView.placeholderColor = [Common colorFromHexRGB:@"525c6b"];
        textView.font = [UIFont systemFontOfSize:16];
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = [Common colorFromHexRGB:@"344357"].CGColor;
        textView.layer.cornerRadius = 3;
        textView.layer.masksToBounds = YES;
        [textView setTextDidChange:^(NSString *str) {
            NSLog(@"ddd");
        }];
        textView.backgroundColor = [Common colorFromHexRGB:@"303f53"];
        [bgView addSubview:textView];
        
        iconI.sd_layout.leftSpaceToView(_headerView, 0).topSpaceToView(_headerView, 0).widthIs(kScreenWidth).heightIs(KHeaderViewH);
        
        inputImageV.sd_layout.leftSpaceToView(bgView, 33).topSpaceToView(bgView, 15).widthIs(13).heightIs(13);
        
        lineView.sd_layout.leftSpaceToView(bgView, 61).topEqualToView(inputImageV).widthIs(4).heightIs(30);
        
        imageV.sd_layout.centerXEqualToView(lineView).centerYEqualToView(inputImageV).widthIs(15).heightIs(15);
        
        textView.sd_layout.leftSpaceToView(bgView, 78).rightSpaceToView(bgView, 10).centerYEqualToView(imageV).heightIs(30);
        
        bgView.sd_layout.leftSpaceToView(_headerView, 0).rightSpaceToView(_headerView, 0).topSpaceToView(iconI, 0).heightIs(45);
        [_headerView setupAutoHeightWithBottomView:bgView bottomMargin:0];
        
        [_headerView layoutSubviews];
    }
    return _headerView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_homeModel.open) {
        if (_homeModel.indexModel.homeCommentModel.show) {
            return _homeModel.index;
        }else {
            return _homeModel.comment.count;
        }
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCommentCell *cell = [HomeCommentCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.modelFrame = _homeModel.comment[indexPath.row];
    if (_homeModel.comment.count - 1 == indexPath.row) {
        cell.lineView1.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCommentModelFrame *modelFrame = _homeModel.comment[indexPath.row];
    return modelFrame.cellHeight;
}

#pragma mark HomeCommentCellDelegate
- (void)clickMoreBtn {
    _homeModel.indexModel.homeCommentModel.show = NO;
    for (HomeCommentModelFrame *commentModelF in _homeModel.comment) {
        commentModelF.homeCommentModel.open = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self.commentBtn.indexPath];
}

@end
