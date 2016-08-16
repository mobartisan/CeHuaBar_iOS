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
#import "ButtonIndexPath.h"
#import "DataManager.h"
#import "JJPhotoManeger.h"

@interface VoteHomeCell ()

@property (strong, nonatomic) DataManager *manager;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation VoteHomeCell

- (DataManager *)manager {
    if (_manager == nil) {
        _manager = [DataManager mainSingleton];
    }
    return _manager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell4" bundle:nil] forCellReuseIdentifier:@"cellIdentifier4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell5" bundle:nil] forCellReuseIdentifier:@"cellIdentifier5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeCellModel *cellModel = self.manager.dataSource[self.indexPath.row];
    HomeDetailCellModel *model = cellModel.comment[self.manager.index1];
    if (model.isClick) {
        return cellModel.comment.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *cellModel = self.manager.dataSource[self.indexPath.row];
    HomeDetailCellModel *model = cellModel.comment[indexPath.row];
    if (model.typeCell == TypeCellTimeAndTitle) {
        HomeDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier4"];
        [cell configureCellWithModel:model];
        if (indexPath.row == cellModel.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        
        return cell;
    }else if (model.typeCell == TypeCellName){
        HomeDetailCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier5"];
        kWeakObject(cell);
        if (!model.isClick) {
            cell.moreBtn.hidden = NO;
        }
        cell.clickBlock = ^() {
            self.manager.index1 = indexPath.row;
            weakObject.moreBtn.hidden = YES;
            model.isClick = YES;
            [tableView reloadData];
            CGFloat height = self.tableView.contentSize.height;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isClick" object:@{@"height":@(height), @"type":@"1"}];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *cellModel = self.manager.dataSource[self.indexPath.row];
    HomeDetailCellModel *model = cellModel.comment[indexPath.row];
    if (model.typeCell == TypeCellTimeAndTitle) {
        return 40;
    }else if (model.typeCell == TypeCellName){
        if (model.isClick) {
            return 40;
        }
        return 80;
    }
    return 0;
}

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

- (void)configureCellWithModel:(HomeCellModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
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
    
}

@end
