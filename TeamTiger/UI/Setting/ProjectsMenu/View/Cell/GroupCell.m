//
//  GroupCell.m
//  TeamTiger
//
//  Created by xxcao on 2016/12/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupCell.h"
#import "UITextField+Extension.h"
#import "MBProgressHUD.h"

@interface GroupCell ()<UITextFieldDelegate>

@end

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.nameTxtField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTxtField addTarget:self action:@selector(handleTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    //     UIButton *button = [self.nameTxtField valueForKey:@"_clearButton"];
    //    button.tintColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)handleTextFieldChange:(UITextField *)textField {
    //1.过滤表情
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
    
    if (![noEmojiStr isEqualToString:textField.text]) {
        textField.text = noEmojiStr;
    }
    //2.限制长度
    [textField beyondMaxLength:40 BeyondBlock:^(BOOL isBeyond) {
        if (isBeyond) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"字数超出上限";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
    
    if (self.endEditBlock) {
        self.endEditBlock(self, textField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
