//
//  HomeDetailCell4.m
//  TeamTiger
//
//  Created by Dale on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell4.h"
#import "HomeDetailCellModel.h"

@interface HomeDetailCell4 ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;

@end

@implementation HomeDetailCell4

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
