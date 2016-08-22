//
//  HomeDetailCell6.m
//  TeamTiger
//
//  Created by Dale on 16/8/20.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell6.h"
#import "HomeDetailCellModel.h"

@implementation HomeDetailCell6

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
    self.nameLB.text = model.firstName;
    self.typeLB.text = model.secondName;
}

@end
