//
//  HomeDetailCell5.h
//  TeamTiger
//
//  Created by Dale on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDetailCellModel, ButtonIndexPath;

@interface HomeDetailCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet ButtonIndexPath *moreBtn;
@property (nonatomic, copy) ClickBlock clickBlock;

- (void)configureCellWithModel:(HomeDetailCellModel *)model;
@end
