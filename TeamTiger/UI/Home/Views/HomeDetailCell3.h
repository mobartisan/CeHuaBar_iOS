//
//  HomeDetailCell3.h
//  TeamTiger
//
//  Created by Dale on 16/8/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailCellModel.h"

@interface HomeDetailCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLB;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLB;
@property (weak, nonatomic) IBOutlet UILabel *descipitionLB;
@property (weak, nonatomic) IBOutlet UIImageView *icon_point;

@property (weak, nonatomic) IBOutlet UIView *lineView2;

- (void)configureCellWithModel:(HomeDetailCellModel *)model;

@end
