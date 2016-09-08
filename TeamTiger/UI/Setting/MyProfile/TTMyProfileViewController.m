//
//  TTMyProfileViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "IQKeyboardManager.h"
#import "MockDatas.h"
#import "ProfileCell.h"
#import "TTMyProfileViewController.h"
#import "TTNotificationSetting.h"
#import "UIAlertView+HYBHelperKit.h"
#import "TTMyModifyViewController.h"

@interface TTMyProfileViewController ()

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation TTMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    return [ProfileCell loadCellHeightWithType:[dic[@"Type"] intValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    static NSString *cellID = @"cellIdentify";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [ProfileCell loadCellWithType:[dic[@"Type"] intValue]];
    }
    [cell reloadCellData:dic];
    cell.block = ^(ProfileCell *cell,int type){
        //微信头像 无法修改
        if (type == 1) {
            NSLog(@"微信头像，无法修改");
        } else {
            NSLog(@"退出登录");
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"确定要退出吗？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                    shake.fromValue = [NSNumber numberWithFloat:-M_PI_4 / 24.0];
                    shake.toValue   = [NSNumber numberWithFloat:+M_PI_4 / 24.0];
                    shake.duration = 0.1;
                    shake.autoreverses = YES;
                    shake.repeatCount = 6;
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [[UIApplication sharedApplication].delegate applicationDidEnterBackground:[UIApplication sharedApplication]];
                    [window.layer addAnimation:shake forKey:@"shakeAnimation"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        exit(0);
                    });
                }
            }];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            NSMutableDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
            TTMyModifyViewController *myModifyVC = [[TTMyModifyViewController alloc] init];
            myModifyVC.name = dic[@"Name"];
            [myModifyVC setPassValue:^(NSString *value) {
                if (![Common isEmptyString:value]) {
                    dic[@"Description"] = value;
                }
            }];
            [self.navigationController pushViewController:myModifyVC animated:YES];
        }
    }else if (indexPath.section == 1) {
        TTNotificationSetting *notificationVC = [[TTNotificationSetting alloc] init];
        [self.navigationController pushViewController:notificationVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }else if (section == 2) {
        return 5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kRGB(27, 36, 50);
    return bgView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSDictionary *dic = [MockDatas testerInfo];
        _dataSource = @[
                        @[
                            @{@"Type":@0,@"Name":@"头像",@"Description":@"",@"ShowAccessory":@1,@"IsEdit":@0,@"Color":kRGB(27.0, 41.0, 58.0),@"HeadImage":dic[@"HeadImage"]}.mutableCopy,
                            @{@"Type":@1,@"Name":@"名字",@"Description":dic[@"Name"],@"ShowAccessory":@1,@"IsEdit":@1,@"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy,
                            @{@"Type":@1,@"Name":@"备注",@"Description":dic[@"Remarks"],@"ShowAccessory":@1,@"IsEdit":@1,@"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy,
                            @{@"Type":@1,@"Name":@"账号",@"Description":dic[@"Account"],@"ShowAccessory":@0,@"IsEdit":@0,@"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy
                            ],
                        @[
                            @{@"Type":@1,@"Name":@"新消息通知",@"Description":@"",@"ShowAccessory":@1,@"IsEdit":@0,@"Color":kRGB(27.0, 41.0, 58.0)}
                            ],
                        @[
                            @{@"Type":@2,@"Name":@"",@"Description":@"",@"ShowAccessory":@0,@"IsEdit":@0,@"Color":[UIColor clearColor]}
                            ]].mutableCopy;
    }
    return  _dataSource;
}
@end
