//
//  DiscussListCell.h
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussListModel;

@interface DiscussListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withModel:(DiscussListModel *)model;
- (void)configureCellWithModel:(DiscussListModel *)model withHideLineView:(BOOL)hiden;

@end
