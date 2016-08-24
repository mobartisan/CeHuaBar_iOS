//
//  HomeDetailCell2.m
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell2.h"
#import "HomeDetailCellModel.h"

@interface HomeDetailCell2 ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@end

@implementation HomeDetailCell2

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
}

@end
