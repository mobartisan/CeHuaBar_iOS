//
//  TTSettingViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/27.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "Constant.h"
#import "IQKeyboardManager.h"
#import "MockDatas.h"
#import "ProjectCell.h"
#import "SelectCircleViewControllerForSetting.h"
#import "TTSelectGroupViewController.h"
#import "TTSettingViewController.h"
#import "UIAlertView+HYBHelperKit.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"


@interface TTSettingViewController ()<WXApiManagerDelegate>

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSMutableDictionary *currentGroupInfo;

@end

@implementation TTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目设置";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    return [ProjectCell loadCellHeightWithData:dic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    static NSString *cellID = @"cellIdentify";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [ProjectCell loadCellWithType:[dic[@"Type"] intValue]];
    }
    [cell reloadCellData:dic];
    cell.block = ^(ProjectCell *cell,int type){
        if (type == EProjectSelect) {
            SelectCircleViewControllerForSetting *selectCircleVC = [[SelectCircleViewControllerForSetting alloc] init];
            selectCircleVC.groupInfo = self.currentGroupInfo;
            WeakSelf;
            selectCircleVC.selectCircleVCBlock = ^(id selectObject, SelectCircleViewControllerForSetting *selectCircleVC){
                [wself loadProjectDataByInfo:selectObject];
            };
            [self.navigationController pushViewController:selectCircleVC animated:YES];
        }
        else if (type == EProjectGroup) {
            TTSelectGroupViewController *selectGroupVC = [[TTSelectGroupViewController alloc] initWithNibName:@"TTSelectGroupViewController" bundle:nil];
            selectGroupVC.selectedGroup = self.currentGroupInfo;
            WeakSelf;
            selectGroupVC.selectGroupBlock = ^(TTSelectGroupViewController *sgVC, NSMutableDictionary *mDic){
                [wself loadGroupDataByInfo:mDic];
            };
            [self.navigationController pushViewController:selectGroupVC animated:YES];
        }
        else if (type == EProjectAddMember){
            NSLog(@"跳转微信，增加人员");
            UIImage *thumbImage = [UIImage imageNamed:@"2.png"];
            [WXApiRequestHandler sendLinkURL:kLinkURL
                                     TagName:kLinkTagName
                                       Title:kLinkTitle
                                 Description:kLinkDescription
                                  ThumbImage:thumbImage
                                     InScene:WXSceneSession];
        } else if (type == EProjectDleteProject){
            NSLog(@"删除并退出");
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"确定要删除并退出该项目？" buttonTitles:@[@"确定",@"取消"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    //TO DO HERE
                }
            }];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kRGB(27, 36, 50);
        return bgView;
    }
    return nil;
}

#pragma -mark Customer Methods
- (void)loadProjectDataByInfo:(id)projectInfo {
    NSMutableDictionary *projectDic = self.dataSource[0];
    projectDic[@"Description"] = projectInfo[@"Name"];

    NSMutableDictionary *membersDic = self.dataSource[2];
    membersDic[@"Members"] = [MockDatas membersOfproject:projectInfo[@"Id"]];

    [self.contentTable reloadData];
}

- (void)loadGroupDataByInfo:(id)groupInfo {
    NSString *projectId = [groupInfo[@"Pids"] componentsSeparatedByString:@","].firstObject;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Id"] isEqualToString:projectId];
    }];
    NSArray *resArray = [[MockDatas projects] filteredArrayUsingPredicate:predicate];
    if (resArray && resArray.count > 0) {

        NSMutableDictionary *projectDic = self.dataSource[0];
        projectDic[@"Description"] = resArray.firstObject[@"Name"];
        
        NSMutableDictionary *groupDic = self.dataSource[1];
        groupDic[@"Description"] = groupInfo[@"Name"];
        
        NSMutableDictionary *membersDic = self.dataSource[2];
        membersDic[@"Members"] = [MockDatas membersOfproject:projectId];
        
        [self.contentTable reloadData];
        //当前分组
        self.currentGroupInfo = groupInfo;
    }
}

#pragma -mark getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSDictionary *group = [MockDatas groups].firstObject;
        //当前分组
        self.currentGroupInfo = group.mutableCopy;

        NSString *projectId = [group[@"Pids"] componentsSeparatedByString:@","].firstObject;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject[@"Id"] isEqualToString:projectId];
        }];
        NSArray *resArray = [[MockDatas projects] filteredArrayUsingPredicate:predicate];
        if (resArray && resArray.count > 0) {
            _dataSource = @[
                            @{@"Type":@0,
                              @"Name":@"项目",
                              @"Description":resArray.firstObject[@"Name"],
                              @"ShowAccessory":@1,
                              @"IsEdit":@0,
                              @"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy,
                            @{@"Type":@1,
                              @"Name":@"组",
                              @"Description":group[@"Name"],
                              @"ShowAccessory":@1,
                              @"IsEdit":@0,
                              @"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy,
                            @{@"Type":@2,
                              @"Name":@"项目成员",
                              @"Description":@"",
                              @"ShowAccessory":@0,
                              @"IsEdit":@0,
                              @"Color":kRGB(27.0, 41.0, 58.0),
                              @"Members":[MockDatas membersOfproject:projectId]}.mutableCopy,
                            
                            @{@"Type":@3,
                              @"Name":@"",
                              @"Description":@"",
                              @"ShowAccessory":@0,
                              @"IsEdit":@0,
                              @"Color":[UIColor clearColor]}.mutableCopy].mutableCopy;
        }
    }
    return _dataSource;
}


#pragma -mark WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request {
    
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request {
    
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request {
    
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    //    返回应用时，收到消息回调
    NSLog(@"ddddddd");
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
}

@end
