//
//  VoteHomeCell.m
//  TeamTiger
//
//  Created by Dale on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "VoteHomeCell.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "HomeDetailCell4.h"
#import "HomeDetailCell5.h"
#import "HomeDetailCell6.h"
#import "ButtonIndexPath.h"
#import "JJPhotoManeger.h"


static CGFloat tableViewHeight = 0.0;

@interface VoteHomeCell ()

@property (strong, nonatomic) HomeDetailCellModel *detailModel;

@end

@implementation VoteHomeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell4" bundle:nil] forCellReuseIdentifier:@"cellIdentifier4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell5" bundle:nil] forCellReuseIdentifier:@"cellIdentifier5"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell6" bundle:nil] forCellReuseIdentifier:@"cellIdentifier6"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


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
    if (detailModel.typeCell == TypeCellTitleNoButton) {
        HomeDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier4"];
        [cell configureCellWithModel:detailModel];
        return cell;
    }else if(detailModel.typeCell == TypeCellTitle){
        HomeDetailCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier5"];
        [cell configureCellWithModel:detailModel];
        cell.clickBlock = ^() {
            self.detailModel = detailModel;
            detailModel.isClick = YES;
            detailModel.typeCell = TypeCellTitleNoButton;
            [self.tableView reloadData];
            _model.height = 0;
            if ([self.delegate respondsToSelector:@selector(reloadTableViewWithHeight:withIndexPath:)]) {
                [self.delegate reloadTableViewWithHeight:0.0 withIndexPath:nil];
            }
        };
        return cell;
    }else {
        HomeDetailCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier6"];
        if (indexPath.row == _model.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        [cell configureCellWithModel:detailModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *model = _model.comment[indexPath.row];
    if (model.typeCell == TypeCellTitleNoButton) {
        return 35;
    }else if (model.typeCell == TypeCellTitle){
        return 65;
    }else {
        return 35;
    }
}

//投票
- (IBAction)handleBtnAction:(UIButton *)sender {
    UIButton *btn = nil;
    switch (sender.tag) {
        case 100:
            btn = self.aBtn;
            break;
        case 101:
            btn = self.bBtn;
            break;
        case 102:
            btn = self.cBtn;
            break;
        default:
            break;
    }
    if (self.clickBtn) {
        self.clickBtn(btn);
    }
}

//图片
- (IBAction)handleClickImageAction:(UIButton *)sender {
    UIImageView *image = nil;
    switch (sender.tag) {
        case 200:
            image = self.image1;
            break;
        case 201:
            image = self.image2;
            break;
        case 202:
            image = self.image3;
            break;
        default:
            break;
    }
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showNetworkPhotoViewer:@[self.image1, self.image2, self.image3] urlStrArr:nil selecView:image];
    
}

- (void)setModel:(HomeCellModel *)model {
    _model = model;
    
    self.headImage.image = kImage(model.headImage);
    self.nameLB.text = model.name;
    self.typeLB.text = model.type;
    self.image1.image = kImage(model.image1);
    self.image2.image = kImage(model.image2);
    self.image3.image = kImage(model.image3);
    self.aDesLB.text = model.aDes;
    self.bDesLB.text = model.bDes;
    self.cDesLB.text = model.cDes;
    self.aProgress.progress = [model.aTicket floatValue];
    self.bProgress.progress = [model.bTicket floatValue];
    self.cProgress.progress = [model.cTicket floatValue];
    
    self.aTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.aTicket.floatValue) * 10];
    self.bTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.bTicket.floatValue) * 10];
    self.cTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.cTicket.floatValue) * 10];
    
    self.aPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.aTicket.floatValue) * 100];
    self.bPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.bTicket.floatValue) * 100];
    self.cPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.cTicket.floatValue) * 100];
    
    if (model.isClick == NO) {
        if (_detailModel != nil) {
            _detailModel.isClick = NO;
            _detailModel.typeCell = TypeCellTitle;
            [self.tableView reloadData];
        }
    }
    
    CGFloat height = 0;
    NSMutableArray *cellHeightArr = [NSMutableArray array];
    NSMutableArray *cellHeight1Arr = [NSMutableArray array];
    NSMutableArray *cellHeight2Arr = [NSMutableArray array];
    if (model.isClick) {
        for (HomeDetailCellModel *detailModel in model.comment) {
            if (detailModel.typeCell == TypeCellTitleNoButton) {
                [cellHeightArr addObject:detailModel];
            } else if (detailModel.typeCell == TypeCellTitle) {
                [cellHeight1Arr addObject:detailModel];
                if (detailModel.isClick == NO) {
                    break;
                }
            }else if (detailModel.typeCell == TypeCellTime) {
                [cellHeight2Arr addObject:detailModel];
            }
        }
    }
    height =  35 * ((int)cellHeightArr.count)  + 65 * ((int)cellHeight1Arr.count) + 35 * ((int)cellHeight2Arr.count);
    if (_model.height == 0) {
        _model.height = height;
    }
    tableViewHeight = _model.height;
}

+ (CGFloat)tableViewHeight {
    return tableViewHeight;
}


@end
