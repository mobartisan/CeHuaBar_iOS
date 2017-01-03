//
//  HomeVoteCell.h
//  TeamTiger
//
//  Created by Dale on 16/11/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel, ButtonIndexPath;

@protocol HomeVoteCellDelegate <NSObject>

- (void)clickVoteBtn:(NSIndexPath *)indexPath;
- (void)clickVoteProjectBtn:(TT_Project *)project;
- (void)clickVoteSuccess:(NSIndexPath *)indexPath homeModel:(HomeModel *)model;


@end

@interface HomeVoteCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) HomeModel *homeModel;
@property (assign, nonatomic) id <HomeVoteCellDelegate> delegate;
@property (strong, nonatomic) ButtonIndexPath *projectBtn;

@end
