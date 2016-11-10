//
//  HomeVoteCell.h
//  TeamTiger
//
//  Created by Dale on 16/11/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel;

@interface HomeVoteCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) HomeModel *homeModel;

@end
