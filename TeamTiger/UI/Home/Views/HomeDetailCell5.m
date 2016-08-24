//
//  HomeDetailCell5.m
//  TeamTiger
//
//  Created by Dale on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell5.h"
#import "HomeDetailCellModel.h"

@interface HomeDetailCell5 ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;

@end

@implementation HomeDetailCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleClickAction:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)configureCellWithModel:(HomeDetailCellModel *)model {
    self.timeLB.text = model.time;
    self.nameLB.text = model.firstName;
    self.typeLB.text = model.secondName;
}

@end
