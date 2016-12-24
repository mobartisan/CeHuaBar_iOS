//
//  HomeCell.h
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel, ButtonIndexPath, TableViewIndexPath;

@protocol HomeCellDelegate <NSObject>
- (void)clickCommentBtn:(NSIndexPath *)indexPath;
- (void)clickProjectBtn:(NSString *)projectId;

@end

@interface HomeCell : UITableViewCell

@property (strong, nonatomic) HomeModel *homeModel;
@property (strong, nonatomic) ButtonIndexPath *commentBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) id <HomeCellDelegate> delegate;
@property (copy, nonatomic) void (^clickMoreBtnBlock)(NSIndexPath *indexPath);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
