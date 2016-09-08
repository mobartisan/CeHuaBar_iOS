//
//  HomeDetailCell.h
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDetailCellModel;

@interface HomeDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon_point;

- (void)configureCellWithModel:(HomeDetailCellModel *)model;

@end
