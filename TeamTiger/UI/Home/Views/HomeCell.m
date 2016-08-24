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

@end

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    height =  160 * ((int)cellHeightArr.count)  + 60 * ((int)cellHeight1Arr.count) + 100 * ((int)cellHeight2Arr.count) + 30 * ((int)cellHeight3Arr.count);
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
                [self.delegate reloadHomeTableView:self.indexPath];
            }
        };
        [cell configureCellWithModel:detailModel];
        return cell;
    }else if (detailModel.typeCell == TypeCellTime){
        HomeDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
        [cell configureCellWithModel:detailModel];
        return cell;
    }else { //TypeCellTitleNoButton
        HomeDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier3"];
        cell.lineView2.hidden = NO;
        if (indexPath.row == _model.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        [cell configureCellWithModel:detailModel];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *datailModel = _model.comment[indexPath.row];
    switch (datailModel.typeCell) {
        case TypeCellImage:
            return 160;
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

- (IBAction)handleClickImageAction:(UIButton *)sender {
    UIImageView *image = nil;
    switch (sender.tag) {
        case 100:
            image = self.image1;
            break;
        case 101:
            image = self.image2;
            break;
        case 102:
            image = self.image3;
            break;
        default:
            break;
    }
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showNetworkPhotoViewer:@[self.image1, self.image2, self.image3] urlStrArr:nil selecView:image];
    
}

@end
