//
//  HomeCell.h
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel, ButtonIndexPath, TableViewIndexPath;

@interface HomeCell : UITableViewCell

@property (strong, nonatomic) HomeModel *homeModel;
@property (strong, nonatomic) ButtonIndexPath *commentBtn;
@property (strong, nonatomic) TableViewIndexPath *tableView;
@property (copy, nonatomic) void(^CommentBtnClick)(NSIndexPath *indexPath);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
