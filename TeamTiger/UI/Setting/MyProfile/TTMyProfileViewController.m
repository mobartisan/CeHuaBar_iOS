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


@interface TTMyProfileViewController ()

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation TTMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    return [ProfileCell loadCellHeightWithType:[dic[@"Type"] intValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
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
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        TTNotificationSetting *notificationVC = [[TTNotificationSetting alloc] init];
        [self.navigationController pushViewController:notificationVC animated:YES];
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSDictionary *dic = [MockDatas testerInfo];
        _dataSource = @[
  @{@"Type":@0,@"Name":@"",@"Description":@"",@"ShowAccessory":@0,@"IsEdit":@0,@"Color":kRGB(21.0, 30.0, 44.0),@"HeadImage":dic[@"HeadImage"]},
  @{@"Type":@1,@"Name":@"名字",@"Description":dic[@"Name"],@"ShowAccessory":@1,@"IsEdit":@1,@"Color":kRGB(25.0, 34.0, 49.0)},
  @{@"Type":@1,@"Name":@"账号",@"Description":dic[@"Account"],@"ShowAccessory":@0,@"IsEdit":@0,@"Color":kRGB(26.0, 38.0, 55.0)},
  @{@"Type":@1,@"Name":@"新消息通知",@"Description":@"",@"ShowAccessory":@1,@"IsEdit":@0,@"Color":kRGB(31.0, 42.0, 63.0)},
  @{@"Type":@2,@"Name":@"",@"Description":@"",@"ShowAccessory":@0,@"IsEdit":@0,@"Color":[UIColor clearColor]}].mutableCopy;
    }
    return  _dataSource;
}
@end
