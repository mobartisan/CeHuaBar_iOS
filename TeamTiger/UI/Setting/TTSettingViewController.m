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
#import "TTPickerView.h"
#import "TTSettingViewController.h"
#import "UIAlertView+HYBHelperKit.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"


@interface TTSettingViewController ()<WXApiManagerDelegate>

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)TTPickerView *ttPicker;

@end

@implementation TTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目设置";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [Common customPopAnimationFromNavigation:wself.navigationController Type:kCATransitionPush SubType:kCATransitionFromRight];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;
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
//            [self ttPicker];
            SelectCircleViewControllerForSetting *selectCircleVC = [[SelectCircleViewControllerForSetting alloc] init];
            selectCircleVC.title = @"选择项目";
            WeakSelf;
            selectCircleVC.selectCircleVCBlock = ^(id selectObject, SelectCircleViewControllerForSetting *selectCircleVC){
                [wself loadProjectDataById:selectObject[@"Id"]];
            };
            [self.navigationController pushViewController:selectCircleVC animated:YES];
        }
//        else if (type == EProjectAddMember){
//            [self ttPicker];
//        }
        else if (type == EProjectGroup) {
            TTSelectGroupViewController *selectGroupVC = [[TTSelectGroupViewController alloc] initWithNibName:@"TTSelectGroupViewController" bundle:nil];
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
- (void)loadProjectDataById:(id)projectId {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Id"] isEqualToString:projectId];
    }];
    NSArray *resArray = [[MockDatas projects] filteredArrayUsingPredicate:predicate];
    if (resArray && resArray.count > 0) {
        [self.dataSource removeAllObjects];
        self.dataSource = @[
                        @{@"Type":@0,
                          @"Name":@"项目",
                          @"Description":resArray.firstObject[@"Name"],
                          @"ShowAccessory":@1,
                          @"IsEdit":@0,
                          @"Color":kRGB(27.0, 41.0, 58.0)},
                        @{@"Type":@1,
                          @"Name":@"组",
                          @"Description":@"我创建的项目",
                          @"ShowAccessory":@1,
                          @"IsEdit":@0,
                          @"Color":kRGB(27.0, 41.0, 58.0)},
                        @{@"Type":@2,
                          @"Name":@"项目成员",
                          @"Description":@"",
                          @"ShowAccessory":@0,
                          @"IsEdit":@0,
                          @"Color":kRGB(27.0, 41.0, 58.0),
                          @"Members":[MockDatas membersOfproject:projectId]},
                        
                        @{@"Type":@3,
                          @"Name":@"",
                          @"Description":@"",
                          @"ShowAccessory":@0,
                          @"IsEdit":@0,
                          @"Color":[UIColor clearColor]}].mutableCopy;
        
        [self.contentTable reloadData];
    }
}

#pragma -mark getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
    @{@"Type":@0,
      @"Name":@"项目",
      @"Description":[MockDatas projects][0][@"Name"],
      @"ShowAccessory":@1,
      @"IsEdit":@0,
      @"Color":kRGB(27.0, 41.0, 58.0)},
    @{@"Type":@1,
      @"Name":@"组",
      @"Description":@"我创建的项目",
      @"ShowAccessory":@1,
      @"IsEdit":@0,
      @"Color":kRGB(27.0, 41.0, 58.0)},
    @{@"Type":@2,
      @"Name":@"项目成员",
      @"Description":@"",
      @"ShowAccessory":@0,
      @"IsEdit":@0,
      @"Color":kRGB(27.0, 41.0, 58.0),
      @"Members":[MockDatas membersOfproject:[MockDatas projects][0][@"Id"]]},
    
    @{@"Type":@3,
      @"Name":@"",
      @"Description":@"",
      @"ShowAccessory":@0,
      @"IsEdit":@0,
      @"Color":[UIColor clearColor]}].mutableCopy;
    }
    return  _dataSource;
}


- (TTPickerView *)ttPicker {
    if (!_ttPicker) {
        WeakSelf;
        _ttPicker = [[TTPickerView alloc] initWithDatas:[MockDatas projects] SelectBlock:^(TTPickerView *view, id selObj) {
            NSLog(@"%@",selObj);
            [wself loadProjectDataById:selObj[@"Id"]];
        } TapBlock:^(TTPickerView *view) {
            [UIView animateWithDuration:0.3 animations:^{
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(wself.view.mas_top).offset(200);
                }];
                [wself.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                _ttPicker = nil;
            }];
        }];
        [wself.view addSubview:_ttPicker];
        [_ttPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wself.view.mas_left);
            make.top.mas_equalTo(wself.view.mas_top).offset(200);
            make.height.equalTo(wself.view.mas_height);
            make.width.equalTo(wself.view.mas_width);
        }];
        [wself.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [wself.ttPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(wself.view.mas_top);
            }];
            [wself.view layoutIfNeeded];
        }];
    }
    return _ttPicker;
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
