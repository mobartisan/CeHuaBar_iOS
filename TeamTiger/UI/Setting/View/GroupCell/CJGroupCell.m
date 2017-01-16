//
//  CJGroupCell.m
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "CJGroupCell.h"

@interface CJGroupCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *confirmImageView;

@end

@implementation CJGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = kRGB(33, 46, 63);
    // Initialization code
}

- (void)setGroup:(TT_Group *)group {
    NSLog(@"isLastRow:%zd", self.isLastRow);
    self.lineView.hidden = self.isLastRow;
    _group = group;
    self.titleLabel.text = group.group_name;
}

@end
