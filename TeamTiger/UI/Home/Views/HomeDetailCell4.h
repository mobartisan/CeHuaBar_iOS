//
//  HomeDetailCell4.h
//  TeamTiger
//
//  Created by Dale on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDetailCellModel;

@interface HomeDetailCell4 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView2;

- (void)configureCellWithModel:(HomeDetailCellModel *)model;

@end
