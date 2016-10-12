//
//  TTSelectGroupViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/12.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTSelectGroupViewController.h"
#import "IQKeyboardManager.h"

@interface TTSelectGroupViewController ()

@end

@implementation TTSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择组";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //
    [Common removeExtraCellLines:self.groupTable];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f];
    self.groupTable.backgroundView = bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:30.0/255.0f blue:44.0/255.0f alpha:1.0f];
    }
    cell.textLabel.text = self.groupDatas[indexPath.row][@"GroupName"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if ([self.groupDatas[indexPath.row][@"IsSelected"] intValue] == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *mDic = self.groupDatas[indexPath.row];
    if ([mDic[@"IsSelected"] intValue] == 1) {
        mDic[@"IsSelected"] = @"0";
    } else {
        mDic[@"IsSelected"] = @"1";
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark

- (NSMutableArray *)groupDatas {
    if (!_groupDatas) {
        _groupDatas = [NSMutableArray array];
        
        NSMutableDictionary *mDic1 = @{@"GroupName":@"我创建的项目",@"IsSelected":@"1"}.mutableCopy;
        NSMutableDictionary *mDic2 = @{@"GroupName":@"南京项目组",@"IsSelected":@"0"}.mutableCopy;
        NSMutableDictionary *mDic3 = @{@"GroupName":@"北京的项目",@"IsSelected":@"0"}.mutableCopy;
        NSMutableDictionary *mDic4 = @{@"GroupName":@"我关注的项目",@"IsSelected":@"0"}.mutableCopy;
        
        [_groupDatas addObject:mDic1];
        [_groupDatas addObject:mDic2];
        [_groupDatas addObject:mDic3];
        [_groupDatas addObject:mDic4];
    }
    return _groupDatas;
}

@end
