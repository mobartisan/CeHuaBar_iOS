//
//  GroupCell.m
//  TeamTiger
//
//  Created by xxcao on 2016/12/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupCell.h"

@interface GroupCell ()<UITextFieldDelegate>

@end

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.nameTxtField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.endEditBlock) {
        self.endEditBlock(self, textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
