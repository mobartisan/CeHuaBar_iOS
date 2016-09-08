//
//  HomeCell.m
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeCell.h"
#import "HomeDetailCell.h"
#import "HomeDetailCell1.h"
#import "HomeDetailCell2.h"
#import "HomeDetailCell3.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "ButtonIndexPath.h"
#import "JJPhotoManeger.h"

static CGFloat tableViewHeight = 0.0;

@interface HomeCell ()

@property (strong, nonatomic) HomeDetailCellModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
//单层图片背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
//双层图片背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewDoubleHeight;

@end

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (is40inch) {
        self.bgViewHeight.constant = 200;
        self.bgViewDoubleHeight.constant = 275;
    }else {
        self.bgViewHeight.constant = 220;
        self.bgViewDoubleHeight.constant = 335;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell1" bundle:nil] forCellReuseIdentifier:@"cellIdentifier1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell2" bundle:nil] forCellReuseIdentifier:@"cellIdentifier2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell3" bundle:nil] forCellReuseIdentifier:@"cellIdentifier3"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithModel:(HomeCellModel *)model {
    //cellHeight 四张图片 cellImageHeight 一,二,三,张照片
    CGFloat cellHeight = 0, cellImageHeight = 0;
    if (is40inch) {
        cellHeight = 309;
        cellImageHeight = 229;
    }else {
        cellHeight = 383;
        cellImageHeight = 268;
    }
    if (model.imageCount == 4) {
        if (model.height == 0) {
            if (model.isClick) {
                return cellHeight + [HomeCell tableViewHeight];
            }else {
                return cellHeight;
            }
        }else{
            return cellHeight + model.height;
        }
    }else {
        if (model.height == 0) {
            if (model.isClick) {
                return cellImageHeight + [HomeCell tableViewHeight];
            }else {
                return cellImageHeight;
            }
        }else{
            return cellImageHeight + model.height;
        }
    }
}

+ (instancetype)homeCellWithTableView:(UITableView *)tableView model:(HomeCellModel *)model {
    static NSString *homeCell = @"homeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
    if (cell == nil) {
        if (model.imageCount == 1) {
            cell = LoadFromNib(@"HomeCell");
        }else if (model.imageCount == 2) {
            cell = LoadFromNib(@"HomeCell1");
        }else if (model.imageCount == 3) {
            cell = LoadFromNib(@"HomeCell2");
        }else {
            cell = LoadFromNib(@"HomeCell3");
        }
    }
    return cell;
}

- (void)setModel:(HomeCellModel *)model {
    if (model.isClick) {
        [self.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
    }else {
        [self.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
    }
    _model = model;
    self.timeLB.text = model.time;
    self.headImage.image = kImage(model.headImage);
    self.nameLB.text = model.name;
    self.typeLB.text = model.type;
    self.image1.image = kImage(model.image1);
    self.image2.image = kImage(model.image2);
    self.image3.image = kImage(model.image3);
    self.image4.image = kImage(model.image4);
    for (HomeDetailCellModel *detailModel in _model.comment) {
        if (detailModel.typeCell == TypeCellTitle || detailModel.isTap) {
            self.detailModel = detailModel;
        }
    }
    if (model.isClick == NO) {
        self.detailModel.isClick = NO;
        self.detailModel.typeCell = TypeCellTitle;
    }
    CGFloat height = 0;
    NSMutableArray *cellHeightArr = [NSMutableArray array];
    NSMutableArray *cellHeight1Arr = [NSMutableArray array];
    NSMutableArray *cellHeight2Arr = [NSMutableArray array];
    
    NSMutableArray *cellHeight3Arr = [NSMutableArray array];
    if (model.isClick) {
        for (HomeDetailCellModel *detailModel in model.comment) {
            if (detailModel.typeCell == TypeCellImage) {
                [cellHeightArr addObject:detailModel];
            } else if (detailModel.typeCell == TypeCellTitleNoButton) {
                [cellHeight1Arr addObject:detailModel];
            }else if (detailModel.typeCell == TypeCellTitle) {
                [cellHeight2Arr addObject:detailModel];
                if (detailModel.isClick == NO) {
                    break;
                }
            }else {
                [cellHeight3Arr addObject:detailModel];
            }
        }
    }
    height =  130 * ((int)cellHeightArr.count)  + 60 * ((int)cellHeight1Arr.count) + 100 * ((int)cellHeight2Arr.count) + 30 * ((int)cellHeight3Arr.count);
    if (_model.height == 0) {
        _model.height = height;
    }
    tableViewHeight = _model.height;
}

+ (CGFloat)tableViewHeight {
    return tableViewHeight;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.detailModel.isClick) {
        return _model.comment.count;
    }else {
        for (HomeDetailCellModel *detailModel in _model.comment) {
            if (detailModel.typeCell == TypeCellTitle) {
                NSUInteger index = [_model.comment indexOfObject:detailModel];
                return index + 1;
            }
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *detailModel = _model.comment[indexPath.row];
    if (detailModel.typeCell == TypeCellImage) {
        HomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        [cell configureCellWithModel:detailModel];
        if (_detailModel.isClick) {
            cell.icon_point.image = kImage(@"icon_point");
        }else {
            cell.icon_point.image = kImage(@"icon_point");
        }
        return cell;
    }else if (detailModel.typeCell == TypeCellTitle) {
        HomeDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier1"];
        cell.moreBtn.indexPath = indexPath;
        cell.clickMoreBtn = ^() {
            detailModel.isClick = YES;
            detailModel.isTap = YES;
            detailModel.typeCell = TypeCellTitleNoButton;
            [self.tableView reloadData];
            _model.height = 0;
            if ([self.delegate respondsToSelector:@selector(reloadHomeTableView:)]) {
                [self.delegate reloadHomeTableView:nil];
            }
        };
        [cell configureCellWithModel:detailModel];
        if (_detailModel.isClick) {
            cell.icon_point.image = kImage(@"icon_point");
        }else {
            cell.icon_point.image = kImage(@"icon_point");
        }
        return cell;
    }else if (detailModel.typeCell == TypeCellTime){
        HomeDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
        [cell configureCellWithModel:detailModel];
        if (_detailModel.isClick) {
            cell.icon_point.image = kImage(@"icon_point");
        }else {
            cell.icon_point.image = kImage(@"icon_point");
        }
        return cell;
    }else { //TypeCellTitleNoButton
        HomeDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier3"];
        cell.lineView2.hidden = NO;
        if (indexPath.row == _model.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        [cell configureCellWithModel:detailModel];
        if (_detailModel.isClick) {
            cell.icon_point.image = kImage(@"icon_point");
        }else {
            cell.icon_point.image = kImage(@"icon_point");
        }
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *detailModel = _model.comment[indexPath.row];
    switch (detailModel.typeCell) {
        case TypeCellImage:
            return 130;
            break;
        case TypeCellTitleNoButton:
            return 60;
            break;
        case TypeCellTitle:
            return 100;
            break;
        case TypeCellTime:
            return 30;
            break;
        default:
            break;
    }
    return 0;
}

- (IBAction)hanldeCommentAction:(ButtonIndexPath *)sender {
    self.clickCommentBtn(sender);
    
}

- (IBAction)handleBtnClick:(UIButton *)sender {
    [keyBoardBGView endEditing:YES];
    NSArray *imageArr = nil;
    UIImageView *currentImage = nil;
    switch (sender.tag) {
        case 100:
            currentImage = self.image1;
            break;
        case 101:
            currentImage = self.image2;
            break;
        case 102:{
            currentImage = self.image3;
        }
            break;
        case 103:{
            currentImage = self.image4;
        }
            break;
        default:
            break;
    }
    switch (_model.imageCount) {
        case 1:
            imageArr = @[self.image1];
            break;
        case 2:
            imageArr = @[self.image1, self.image2];
            break;
        case 3:
            imageArr = @[self.image1, self.image2, self.image3];
            break;
        case 4:
            imageArr = @[self.image1, self.image2, self.image3, self.image4];
            break;
        default:
            break;
    }
    JJPhotoManeger *manager = [JJPhotoManeger maneger];
    [manager showNetworkPhotoViewer:imageArr urlStrArr:nil selecView:currentImage];
}


@end
