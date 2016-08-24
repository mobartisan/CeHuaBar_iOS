//
//  HomeDetailCell1.m
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell1.h"

@interface HomeDetailCell1 ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLB;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLB;
@property (weak, nonatomic) IBOutlet UILabel *descipitionLB;

@end

@implementation HomeDetailCell1

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
- (IBAction)handleBtnAction:(ButtonIndexPath *)sender {
    if (self.clickMoreBtn) {
        self.clickMoreBtn();
    }
}


@end
