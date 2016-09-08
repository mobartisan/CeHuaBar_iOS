//
//  TTMyModifyViewController.m
//  TeamTiger
//
//  Created by Dale on 16/9/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTMyModifyViewController.h"

@interface TTMyModifyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *descTF;

@end

@implementation TTMyModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLB.text = [NSString stringWithFormat:@"%@:", self.name];
    [self.descTF setValue:kRGB(42, 56, 72) forKeyPath:@"_placeholderLabel.textColor"];
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.PassValue) {
        self.PassValue(self.descTF.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
