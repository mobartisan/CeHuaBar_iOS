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
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@end

@implementation CJGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.createBtn, 5);
    self.createBtn.layer.borderWidth = 1.5;
    self.createBtn.layer.borderColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1].CGColor;
    
    [self.createBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    [self.createBtn setTitleColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    [self.createBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
    }];
    
    self.lineView.backgroundColor = kRGB(33, 46, 63);
    self.lineView.hidden = self.isLastRow;

}

- (void)setGroup:(TT_Group *)group {
    _group = group;
    self.confirmImageView.hidden = !group.is_allow_delete;
    self.titleLabel.text = group.group_name;
}

@end
