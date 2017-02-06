//
//  TTMyModifyViewController.m
//  TeamTiger
//
//  Created by Dale on 16/9/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTMyModifyViewController.h"

@interface TTMyModifyViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *descTF;

@end

@implementation TTMyModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.descTF becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    self.nameLB.text = [NSString stringWithFormat:@"%@:", self.tempDic[@"Name"]];
    [self.descTF setValue:kRGB(42, 56, 72) forKeyPath:@"_placeholderLabel.textColor"];
    self.descTF.enablesReturnKeyAutomatically = YES;
    self.descTF.placeholder = self.tempDic[@"Description"];
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
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
