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
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HomeModel.h"
#import "HomeCommentCell.h"
#import "ButtonIndexPath.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"
#import "CustomTextField.h"

@interface HomeCell ()<UITableViewDataSource, UITableViewDelegate, HomeCommentCellDelegate, UITextFieldDelegate>

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
    self.iconImV.backgroundColor = [UIColor clearColor];
    self.iconImV.image = [UIImage imageNamed:@"common-headDefault"];
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
    self.tableView.tableHeaderView = [self headerImage];
    
    
    //分割线
    self.separLine = [UIView new];
    self.separLine.backgroundColor = kRGBColor(41, 50, 61);
    [self.contentView addSubview:self.separLine];
    
    
    
    self.iconImV.sd_layout.leftSpaceToView(self.contentView, 17).topSpaceToView(self.contentView, 19).widthIs(37).heightIs(37);
    self.iconImV.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    
    self.nameLB.sd_layout.leftSpaceToView(self.iconImV, 13).topSpaceToView(self.contentView, 20).heightIs(17).rightSpaceToView(self.contentView, 10);
//    [self.nameLB setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.imageV1.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.nameLB, 9).widthIs(8).heightIs(10);
    
    self.projectLB.sd_layout.leftSpaceToView(self.imageV1, 2).topSpaceToView(self.nameLB, 6).heightIs(16);
    [self.projectLB setSingleLineAutoResizeWithMaxWidth:200];
    
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
    
    self.separLine.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(minLineWidth);
}

- (void)handleClickProjectBtnAction:(ButtonIndexPath *)sender {
    TT_Project *tempProject = [[TT_Project alloc] init];
    tempProject.project_id = _homeModel.Id;
    tempProject.name = _homeModel.project;
    if ([self.delegate respondsToSelector:@selector(clickProjectBtn:)]) {
        [self.delegate clickProjectBtn:tempProject];
    }
}

- (void)handleCommentBtnAction:(ButtonIndexPath *)sender {
    _homeModel.open = !_homeModel.open;
    if (sender.isShow) {
        if (_homeModel.open) {
            _homeModel.indexModel.homeCommentModel.show = YES;
        } else {
            for (HomeCommentModelFrame *commentModelF in _homeModel.comment) {
                commentModelF.homeCommentModel.open = NO;
            }
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
    
    _homeModel = homeModel;
    [self.tableView reloadData];
    
    [self.iconImV sd_setImageWithURL:[NSURL URLWithString:homeModel.iconImV] placeholderImage:[UIImage imageNamed:@"common-headDefault"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    self.nameLB.text = homeModel.name;
    self.projectLB.text = homeModel.project;
    self.contentLB.text = homeModel.content;
    self.timeLB.text = homeModel.time;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d", homeModel.count] forState:UIControlStateNormal];
    self.photoContainerView.picPathStringsArray = homeModel.photeNameArry;
    self.photoContainerView.content = homeModel.content;
    
    //图片
    if (homeModel.photeNameArry.count > 0) {
        _photoContainerView.sd_layout.topSpaceToView(self.contentLB,10);
    } else {
        _photoContainerView.sd_layout.topSpaceToView(self.contentLB,0);
    }
    if (_homeModel.open) {
        self.tableView.hidden = NO;
        if (_homeModel.indexModel.homeCommentModel.show) {
            self.tableView.sd_layout.heightIs(homeModel.partHeight + 60);
        }else {
            self.tableView.sd_layout.heightIs(homeModel.totalHeight + 60);
        }
        self.separLine.sd_layout.topSpaceToView(self.tableView, 10);
    } else {
        self.tableView.hidden = YES;
        self.tableView.sd_layout.heightIs(0);
        self.separLine.sd_layout.topSpaceToView(self.timeLB, 10);
    }
    [self setupAutoHeightWithBottomView:self.separLine bottomMargin:0];
}

- (UIImageView *)headerImage {
    if (_headerImage == nil) {
        _headerImage = [UIImageView new];
        _headerImage.userInteractionEnabled = YES;
        _headerImage.backgroundColor = kRGBColor(28, 37, 51);
        UIImage *img = [UIImage imageNamed:@"bg_discussion"];
        _headerImage.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height - 1, img.size.width * 0.5, 1, img.size.width * 0.5) resizingMode:UIImageResizingModeStretch];
        
        //图片
        UIImageView *inputImageV = [UIImageView new];
        inputImageV.userInteractionEnabled = YES;
        inputImageV.image = kImage(@"icon_write");
        [_headerImage addSubview:inputImageV];
        UITapGestureRecognizer *tapInputImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapInputImage:)];
        [inputImageV addGestureRecognizer:tapInputImage];
        
        
        
        //时间线
        UIView *lineView = [UIView new];
        lineView.tag = 1000;
        lineView.backgroundColor = [Common colorFromHexRGB:@"1b283a"];
        [_headerImage addSubview:lineView];
        
        //亮点
        UIImageView *imageV = [UIImageView new];
        imageV.image = [UIImage imageNamed:@"img_point"];
        [_headerImage addSubview:imageV];
        
        //输入框
        CustomTextField *inputView= [[CustomTextField alloc] init];
        inputView.delegate = self;
        inputView.font = [UIFont systemFontOfSize:16];
        inputView.placeholder = @"讨论：";
        [inputView setValue:[Common colorFromHexRGB:@"525c6b"] forKeyPath:@"_placeholderLabel.textColor"];
        inputView.tintColor = [Common colorFromHexRGB:@"525c6b"];
        inputView.textColor = [UIColor whiteColor];
        inputView.returnKeyType = UIReturnKeyDone;
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = [Common colorFromHexRGB:@"344357"].CGColor;
        inputView.layer.cornerRadius = 3;
        inputView.layer.masksToBounds = YES;
        inputView.backgroundColor = [Common colorFromHexRGB:@"303f53"];
        UIView *view = [[UIView alloc] initWithFrame:Frame(0, 0, 5, 35)];
        inputView.leftView = view;
        inputView.leftViewMode = UITextFieldViewModeAlways;
        [_headerImage addSubview:inputView];
        
        
        inputImageV.sd_layout.leftSpaceToView(_headerImage, 33).topSpaceToView(_headerImage, 25).widthIs(13).heightIs(13);//13 + 25
        
        imageV.sd_layout.leftSpaceToView(_headerImage, 63 - 15 / 2).centerYEqualToView(inputImageV).widthIs(15).heightIs(15);
        
        
        inputView.sd_layout.leftSpaceToView(_headerImage, 78).rightSpaceToView(_headerImage, 5).topSpaceToView(_headerImage, 15).heightIs(35);//15 + 35
        
        lineView.sd_layout.leftSpaceToView(_headerImage, 61).topEqualToView(inputImageV).widthIs(4).heightIs(35); //25 + 35
        
        
        
        UIImageView *sendImage = [UIImageView new];
        sendImage.userInteractionEnabled = YES;
        sendImage.frame = CGRectMake(0, 0, 30, 20);
        sendImage.image = kImage(@"icon_send");
        sendImage.contentMode = UIViewContentModeCenter;
        inputView.rightView = sendImage;
        inputView.rightViewMode = UITextFieldViewModeAlways;
        UITapGestureRecognizer *tapSendImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSendImage:)];
        [sendImage addGestureRecognizer:tapSendImage];
        
        [_headerImage setupAutoHeightWithBottomView:lineView bottomMargin:0];
        [_headerImage layoutSubviews];
    }
    return _headerImage;
}

- (void)handleTapInputImage:(UITapGestureRecognizer *)tap {
    NSLog(@"handleTapInputImage");
    
}

- (void)handleTapSendImage:(UITapGestureRecognizer *)tap {
    UITextField *textF = (UITextField *)tap.view.superview;
    [self sendAMessageWithTextField:textF];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(currentIndexPath:)]) {
        [self.delegate currentIndexPath:self.commentBtn.indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendAMessageWithTextField:textField];
    return YES;
}

//MARK:- 发送讨论
- (void)sendAMessageWithTextField:(UITextField *)txtField {
    UITextField *textF = txtField;
    if ([Common isEmptyString:textF.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入讨论内容";
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    [textF resignFirstResponder];
    
    NSMutableArray *mediasArr = [NSMutableArray array];
    NSData *data = [NSJSONSerialization dataWithJSONObject:mediasArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *urlsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DiscussCreateApi *discussCreatApi = [[DiscussCreateApi alloc] init];
    discussCreatApi.requestArgument = @{@"text":textF.text,
                                        @"pid":_homeModel.Id,
                                        @"type":@0,
                                        @"medias":urlsStr,
                                        @"mid":_homeModel.moment_id};
    [discussCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *dic = @{@"name":[TT_User sharedInstance].nickname,
                                  @"content":textF.text,
                                  @"photeNameArry":mediasArr,
                                  @"time":[Common getCurrentSystemTime]};
            HomeCommentModelFrame *commentModelF = [[HomeCommentModelFrame alloc] init];
            HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic];
            commentModelF.homeCommentModel = commentModel;
            [_homeModel.comment insertObject:commentModelF atIndex:0];
            _homeModel.index += 1;
            _homeModel.count += 1;
            _homeModel.partHeight += commentModelF.cellHeight;
            _homeModel.totalHeight += commentModelF.cellHeight;
            txtField.text = nil;//成功后清空text field
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.label.text = request.responseJSONObject[MSG];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.5];
        }
        if ([self.delegate respondsToSelector:@selector(clickCommentBtn:)]) {
            [self.delegate clickCommentBtn:self.commentBtn.indexPath];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        hud.label.text = @"您的网络好像有问题~";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
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
    if (self.clickMoreBtnBlock) {
        self.clickMoreBtnBlock(self.commentBtn.indexPath);
    }
    
}





@end
