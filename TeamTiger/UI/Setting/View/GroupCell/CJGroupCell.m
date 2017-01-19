//
//  CJGroupCell.m
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "CJGroupCell.h"

@interface CJGroupCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *confirmImageView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTF;

@end

@implementation CJGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineView.backgroundColor = kRGB(33, 46, 63);
    self.lineView.hidden = self.isLastRow;

    [self.groupNameTF setValue:kRGB(66, 74, 86) forKeyPath:@"_placeholderLabel.textColor"];
    self.groupNameTF.textColor = kRGB(66, 74, 86);
    self.groupNameTF.font = [UIFont systemFontOfSize:17];
    [self.groupNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.groupNameTF addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    self.groupNameTF.enablesReturnKeyAutomatically = YES;
    
}
- (void)textLengthChange:(UITextField *)textField {
    if (self.actionBlcok) {
        self.actionBlcok(CJGroupCellClickTypeText,textField.text);
    }
}

- (void)setGroup:(TT_Group *)group {
    _group = group;
    self.confirmImageView.hidden = !group.is_allow_delete;
    self.titleLabel.text = group.group_name;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
            return NO;
        }
    return YES;
}
- (IBAction)handleSelectBtn:(UIButton *)sender {
    if (self.actionBlcok) {
        self.actionBlcok(CJGroupCellClickTypeBtn,nil);
    }
}

@end
