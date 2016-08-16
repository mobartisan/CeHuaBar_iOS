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
#import "DataManager.h"
#import "ButtonIndexPath.h"
#import "JJPhotoManeger.h"

@interface HomeCell ()

@property (strong, nonatomic) DataManager *manager;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation HomeCell

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
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell1" bundle:nil] forCellReuseIdentifier:@"cellIdentifier1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell2" bundle:nil] forCellReuseIdentifier:@"cellIdentifier2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell3" bundle:nil] forCellReuseIdentifier:@"cellIdentifier3"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureCellWithModel:(HomeCellModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.headImage.image = kImage(model.headImage);
    self.nameLB.text = model.name;
    self.typeLB.text = model.type;
    self.image1.image = kImage(model.image1);
    self.image2.image = kImage(model.image2);
    self.image3.image = kImage(model.image3);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeCellModel *cellModel = self.manager.dataSource[self.indexPath.row];
    HomeDetailCellModel *model = cellModel.comment[self.manager.index];
    if (model.isClick) {
        return cellModel.comment.count;
    }else {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *cellModel = self.manager.dataSource[self.indexPath.row];
    HomeDetailCellModel *model = cellModel.comment[indexPath.row];
    if (model.typeCell == TypeCellImage) {
        HomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        [cell configureCellWithModel:model];
        return cell;
    }else if (model.typeCell == TypeCellTitle) {
        HomeDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier1"];
        cell.moreBtn.indexPath = indexPath;
        cell.clickMoreBtn = ^() {
            self.manager.index = indexPath.row;
            model.isClick = YES;
            model.typeCell = TypeCellTitleNoButton;
            [tableView reloadData];
            CGFloat height = self.tableView.contentSize.height;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isClick" object:@{@"height":@(height), @"type":@"0"}];
            
        };
        [cell configureCellWithModel:model];
        return cell;
    }else if (model.typeCell == TypeCellTime){
        HomeDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
        [cell configureCellWithModel:model];
        return cell;
    }else if (model.typeCell == TypeCellTitleNoButton) {
        HomeDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier3"];
        if (indexPath.row == cellModel.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        [cell configureCellWithModel:model];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *cellModel = self.manager.dataSource[indexPath.section];
    HomeDetailCellModel *model = cellModel.comment[indexPath.row];
    switch (model.typeCell) {
        case TypeCellImage:
            return 160;
            break;
        case TypeCellTitle:
            return 100;
            break;
        case TypeCellTime:
            return 30;
            break;
        case TypeCellTitleNoButton:
            return 60;
            break;
        default:
            break;
    }
    return 0;
}

- (IBAction)hanldeCommentAction:(UIButton *)sender {
    NSLog(@"评论");
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
