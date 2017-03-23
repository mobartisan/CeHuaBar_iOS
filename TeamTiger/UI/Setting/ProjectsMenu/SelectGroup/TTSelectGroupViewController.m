//
//  TTSelectGroupViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/12.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTSelectGroupViewController.h"
#import "IQKeyboardManager.h"
#import "MockDatas.h"

@interface TTSelectGroupViewController ()

@end

@implementation TTSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择组";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        if (wself.selectGroupBlock) {
            wself.selectGroupBlock(wself, wself.groupDatas[wself.currentSelectedIndex]);
        }
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    __block NSInteger index = 0;
    [[MockDatas  groups] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"Gid"] isEqualToString:self.selectedGroup[@"Gid"]]) {
            index = idx;
            *stop = YES;
        }
    }];
    self.currentSelectedIndex = index;
    
    //table view
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
    return self.groupDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:30.0/255.0f blue:44.0/255.0f alpha:1.0f];
        UIImageView *lineImgV = [[UIImageView alloc] init];
        [cell addSubview:lineImgV];
        lineImgV.backgroundColor = [UIColor lightGrayColor];
        lineImgV.alpha = 0.5;
        [lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.bottom.equalTo(cell.mas_bottom).offset(-1);
            make.height.mas_equalTo(0.5);
        }];
    }
    cell.textLabel.text = self.groupDatas[indexPath.row][@"Name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if ([self.groupDatas[indexPath.row][@"IsSelected"] intValue] == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentSelectedIndex == indexPath.row) {
        return;
    }
    [self.groupDatas enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj[@"IsSelected"] = @"0";
    }];
    NSMutableDictionary *mDic = self.groupDatas[indexPath.row];
    mDic[@"IsSelected"] = @"1";
    [tableView reloadData];
    self.currentSelectedIndex = indexPath.row;
}

#pragma -mark
- (NSMutableArray *)groupDatas {
    if (!_groupDatas) {
        _groupDatas = [NSMutableArray array];
        NSArray *groups = [MockDatas  groups];
        [groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            if (idx == self.currentSelectedIndex) {
                mDic[@"IsSelected"] = @"1";
            } else {
                mDic[@"IsSelected"] = @"0";
            }
            [_groupDatas addObject:mDic];
        }];
    }
    return _groupDatas;
}

@end
