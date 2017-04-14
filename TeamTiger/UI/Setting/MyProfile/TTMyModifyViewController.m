//
//  TTMyModifyViewController.m
//  TeamTiger
//
//  Created by Dale on 16/9/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTMyModifyViewController.h"
#import "UITextField+Extension.h"
#import "MBProgressHUD.h"

@interface TTMyModifyViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *descTF;

@end

@implementation TTMyModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(28, 37, 51);
    [self.descTF becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    self.nameLB.text = [NSString stringWithFormat:@"%@:", self.tempDic[@"Name"]];
    [self.descTF setValue:kRGB(42, 56, 72) forKeyPath:@"_placeholderLabel.textColor"];
    self.descTF.enablesReturnKeyAutomatically = YES;
    self.descTF.placeholder = self.tempDic[@"Description"];
    self.descTF.tintColor = [UIColor whiteColor];
    [self.descTF addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)textLengthChange:(UITextField *)textField {
    //1.过滤表情
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
    
    if (![noEmojiStr isEqualToString:textField.text]) {
        textField.text = noEmojiStr;
    }
    //2.限制长度
    [textField beyondMaxLength:60 BeyondBlock:^(BOOL isBeyond) {
        if (isBeyond) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"字数超出上限";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.descTF resignFirstResponder];
    if (self.PassValue) {
        self.PassValue(self.descTF.text);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.descTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.descTF resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
