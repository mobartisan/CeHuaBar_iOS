//
//  HomeDetailCell3.m
//  TeamTiger
//
//  Created by Dale on 16/8/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell3.h"

@implementation HomeDetailCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(HomeDetailCellModel *)model {
    self.timeLB.text = model.time;
    self.firstNameLB.text = model.firstName;
    self.secondNameLB.text = model.secondName;
    self.descipitionLB.text = model.des;
}

@end
