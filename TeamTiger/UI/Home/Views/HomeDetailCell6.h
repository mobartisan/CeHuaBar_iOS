//
//  HomeDetailCell6.h
//  TeamTiger
//
//  Created by Dale on 16/8/20.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDetailCellModel;

@interface HomeDetailCell6 : UITableViewCell



@property (weak, nonatomic) IBOutlet UIView  *lineView2;
- (void)configureCellWithModel:(HomeDetailCellModel *)model;

@end
