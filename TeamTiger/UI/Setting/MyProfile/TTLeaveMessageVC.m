//
//  TTLeaveMessageVC.m
//  TeamTiger
//
//  Created by Dale on 17/3/27.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTLeaveMessageVC.h"
#import "UITextView+Placeholder.h"

@interface TTLeaveMessageVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TTLeaveMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationItem];
    [self.textView becomeFirstResponder];
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.placeholder = @"请描述你的问题";
    self.textView.backgroundColor = kColorForCommonCellBackgroud;
}

- (void)configureNavigationItem {
    self.title = @"意见反馈";
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    [rightBtn addTarget:self action:@selector(handleRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - 提交反馈信息
- (void)handleRightBtnAction:(UIButton *)sender {
    if ([Common isEmptyString:self.textView.text]) {
        [super showText:@"请输入你的问题" afterSeconds:1.0];
        return;
    }
    [self.textView resignFirstResponder];
    
    FeedBackApi *api = [[FeedBackApi alloc] init];
    api.requestArgument = @{@"content":self.textView.text};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            self.textView.text = nil;
        }
        [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
