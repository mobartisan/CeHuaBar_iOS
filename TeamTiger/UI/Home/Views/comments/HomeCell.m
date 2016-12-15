//
//  HomeCell.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeCell.h"
#import "YZInputView.h"
#import "UITextView+Placeholder.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HomeModel.h"
#import "HomeCommentCell.h"
#import "ButtonIndexPath.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"


@interface HomeCell ()<UITableViewDataSource, UITableViewDelegate, HomeCommentCellDelegate, UITextViewDelegate>

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

@property (strong, nonatomic) UIImageView *headerImage;
@property (assign, nonatomic) CGFloat headerViewH;

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
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kRGBColor(32, 46, 63);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
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
    self.tableView.tableHeaderView = [self headerImage];
    
    _homeModel = homeModel;
    
    [self.tableView reloadData];
    
    [self.iconImV sd_setImageWithURL:[NSURL URLWithString:homeModel.iconImV] placeholderImage:kImage(@"1")];
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
            self.tableView.sd_layout.heightIs(homeModel.partHeight + self.headerViewH);
        }else {
            self.tableView.sd_layout.heightIs(homeModel.totalHeight + self.headerViewH);
        }
        self.separLine.sd_layout.topSpaceToView(self.tableView, 10);
    }else {
        self.tableView.sd_layout.heightIs(0);
        self.separLine.sd_layout.topSpaceToView(self.timeLB, 10);
    }
    [self setupAutoHeightWithBottomView:self.separLine bottomMargin:0];
    
}

- (UIImageView *)headerImage {
    _headerImage = [UIImageView new];
    _headerImage.userInteractionEnabled = YES;
    _headerImage.backgroundColor = kRGBColor(28, 37, 51);
    UIImage *img = [UIImage imageNamed:@"bg_discussion"];
    _headerImage.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height - 1, img.size.width * 0.5, 1, img.size.width * 0.5) resizingMode:UIImageResizingModeStretch];
    
    //输入视图
    UIImageView *inputImageV = [UIImageView new];
    inputImageV.image = kImage(@"icon_write");
    [_headerImage addSubview:inputImageV];
    
    //时间线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [Common colorFromHexRGB:@"1b283a"];
    [_headerImage addSubview:lineView];
    
    //亮点
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"img_point"];
    [_headerImage addSubview:imageV];
    
    //图片按钮
    ButtonIndexPath *imgBtn = [ButtonIndexPath buttonWithType:UIButtonTypeCustom];
    [imgBtn setBackgroundImage:kImage(@"icon_add_group") forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(handelImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerImage addSubview:imgBtn];
    
    YZInputView *inputView= [[YZInputView alloc] init];
    inputView.delegate = self;
    inputView.font = [UIFont systemFontOfSize:16];
    inputView.placeholder = @" 讨论:";
    inputView.placeholderColor = [Common colorFromHexRGB:@"525c6b"];
    inputView.maxNumberOfLines = 1;
    inputView.textColor = [UIColor whiteColor];
    inputView.returnKeyType = UIReturnKeySend;
    inputView.layer.borderWidth = 1;
    inputView.layer.borderColor = [Common colorFromHexRGB:@"344357"].CGColor;
    inputView.layer.cornerRadius = 3;
    inputView.layer.masksToBounds = YES;
    inputView.backgroundColor = [Common colorFromHexRGB:@"303f53"];
    [_headerImage addSubview:inputView];
    
    
    inputImageV.sd_layout.leftSpaceToView(_headerImage, 33).topSpaceToView(_headerImage, 25).widthIs(13).heightIs(13);//20 + 13
    
    imageV.sd_layout.leftSpaceToView(_headerImage, 63 - 15 / 2).centerYEqualToView(inputImageV).widthIs(15).heightIs(15);
    
    imgBtn.sd_layout.rightSpaceToView(_headerImage, 5).topSpaceToView(_headerImage, 23).widthIs(20).heightIs(20);
    
    //20 + 30
    // 监听文本框文字高度改变
    __weak typeof(inputView) weakInput = inputView;
    inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        CGFloat h = textHeight + 20;
        self.headerViewH = h;
        weakInput.sd_layout.leftSpaceToView(_headerImage, 78).rightSpaceToView(imgBtn, 5).topSpaceToView(_headerImage, 15).heightIs(textHeight);
        
        lineView.sd_layout.leftSpaceToView(_headerImage, 61).topEqualToView(inputImageV).widthIs(4).heightIs(textHeight);
    };
    
    [_headerImage setupAutoHeightWithBottomView:lineView bottomMargin:0];
    [_headerImage layoutSubviews];
    return _headerImage;
}

- (void)handelImageAction:(ButtonIndexPath *)sender {
    
}

#warning to do 添加discuss
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              
              NSMutableArray *mediasArr = [NSMutableArray array];
              NSDictionary *dic = @{@"uid":@"82054c40-c2a0-11e6-bec6-71b7651bef6e",//用户唯一标识
                                    @"type":@0,
                                    @"from":@0,
                                    @"url":@"http://ohcjw5fss.bkt.clouddn.com/2016-12-14_qGVkdKC7.png"};
              [mediasArr addObject:dic];
              
              NSData *data = [NSJSONSerialization dataWithJSONObject:mediasArr options:NSJSONWritingPrettyPrinted error:nil];
              NSString *urlsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              DiscussCreateApi *discussCreatApi = [[DiscussCreateApi alloc] init];
              discussCreatApi.requestArgument = @{@"text":textView.text,
                                                  @"pid":_homeModel.Id,
                                                  @"type":@0,
                                                  @"medias":urlsStr,
                                                  @"mid":_homeModel.moment_id};
              [discussCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                  NSLog(@"%@", request.responseJSONObject);
                  NSDictionary *dic = @{@"name":@"曹兴星",
                                        @"content":textView.text,
                                        @"photeNameArry":mediasArr,
                                        @"time":[Common getCurrentSystemTime]};
                  HomeCommentModelFrame *commentModelF = [[HomeCommentModelFrame alloc] init];
                  HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic];
                  commentModelF.homeCommentModel = commentModel;
                  [_homeModel.comment insertObject:commentModelF atIndex:0];
                  _homeModel.index += 1;
                  _homeModel.partHeight +=commentModelF.cellHeight;
                  _homeModel.totalHeight +=commentModelF.cellHeight;
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if ([self.delegate respondsToSelector:@selector(clickCommentBtn:)]) {
                          [self.delegate clickCommentBtn:self.commentBtn.indexPath];
                      }
                  });
              } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                  NSLog(@"%@", error);
                  
              }];
          });
        
        return NO;
    }
    return YES;

                       
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_homeModel.open) {
        return _homeModel.indexModel.homeCommentModel.show ? _homeModel.index : _homeModel.comment.count;
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
