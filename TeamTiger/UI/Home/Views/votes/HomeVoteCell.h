//
//  HomeVoteCell.h
//  TeamTiger
//
//  Created by Dale on 16/11/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel;

@protocol HomeVoteCellDeleagte <NSObject>

- (void)clickVoteProjectBtn:(NSString *)projectId;

@end

@interface HomeVoteCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) HomeModel *homeModel;
@property (assign, nonatomic) id <HomeVoteCellDeleagte> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
