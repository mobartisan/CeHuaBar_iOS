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
    [super viewDidDisappear:animated];
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
            WeakSelf;
            selectCircleVC.selectCircleVCBlock = ^(id selectObject, SelectCircleViewControllerForSetting *selectCircleVC){
                [wself loadProjectDataByInfo:selectObject];
            };
            [self.navigationController pushViewController:selectCircleVC animated:YES];
        }
        else if (type == EProjectAddMember){
            NSLog(@"跳转微信，增加人员");
            UIImage *thumbImage = [UIImage imageNamed:@"AppIcon"];
            
//          方式一:
//                NSData *data = [@"cehuabar" dataUsingEncoding:NSUTF8StringEncoding];
//                [WXApiRequestHandler sendAppContentData:data
//                                                ExtInfo:kAppContentExInfo //拼接参数
//                                                 ExtURL:kAppContnetExURL //可以填app的下载地址
//                                                  Title:kAPPContentTitle
//                                            Description:kAPPContentDescription
//                                             MessageExt:kAppMessageExt
//                                          MessageAction:kAppMessageAction
//                                             ThumbImage:thumbImage
//                                                InScene:WXSceneSession];
//          方式二:
            NSString *name = @"name=xxcao";
            NSString *phone = @"phone=18662724884";
            NSString *composeURL = [NSString stringWithFormat:@"%@?%@&%@",kLinkURL, name, phone];
            [WXApiRequestHandler sendLinkURL:composeURL
                                     TagName:kLinkTagName
                                       Title:kLinkTitle
                                 Description:kLinkDescription
                                  ThumbImage:thumbImage
                                     InScene:WXSceneSession];
        } else if (type == EProjectDleteProject){
            NSLog(@"删除并退出");
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"确定要删除并退出该项目？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    NSString *sql = [NSString stringWithFormat:@"update %@ set current_state = 1",TABLE_TT_Project];//设置为删除状态
                    [SQLITEMANAGER executeSql:sql];
#warning TO DO HERE 跳回主页面，并刷新
                }
            }];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kRGB(27, 36, 50);
        return bgView;
    }
    return nil;
}

#pragma -mark Customer Methods
- (void)loadProjectDataByInfo:(id)projectInfo {
    NSMutableDictionary *projectDic = self.dataSource[0];
    projectDic[@"Description"] = [projectInfo name];

    NSMutableDictionary *membersDic = self.dataSource[1];
    
    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where project_id = '%@'",TABLE_TT_Project_Members,[projectInfo project_id]];
    NSArray *members = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Project_Members];
    membersDic[@"Members"] = members;
    [self.contentTable reloadData];
}

#pragma -mark getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        TT_Project *project = [[TT_Project alloc] init];
        project.name = @"工作牛";
        project.project_id = @"0003";
      

        _dataSource = @[
                        @{@"Type":@0,
                          @"Name":@"项目",
                          @"Description":project.name,
                          @"ShowAccessory":@1,
                          @"IsEdit":@0,
                          @"Color":kRGB(27.0, 41.0, 58.0)}.mutableCopy,
                        @{@"Type":@1,
                          @"Name":@"项目成员",
                          @"Description":@"",
                          @"ShowAccessory":@0,
                          @"IsEdit":@0,
                          @"Color":kRGB(27.0, 41.0, 58.0),
                          @"Members":@[]}.mutableCopy,
                        @{@"Type":@2,
                          @"Name":@"",
                          @"Description":@"",
                          @"ShowAccessory":@0,
                          @"IsEdit":@0,
                          @"Color":[UIColor clearColor]}.mutableCopy].mutableCopy;
    }
    return _dataSource;
}


#pragma -mark WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request {
    
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request {
    //微信回传消息
    [UIAlertView hyb_showWithTitle:@"提示" message:[request.message.mediaObject extInfo] buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {}];
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
