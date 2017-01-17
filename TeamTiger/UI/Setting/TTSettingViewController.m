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
#import "Models.h"
#import "TTSettingGroupViewController.h"

@interface TTSettingViewController ()<WXApiManagerDelegate>

@property(nonatomic,strong)NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *projectMembersArr;
@property(nonatomic,strong)NSMutableDictionary *currentGroupInfo;

@end

@implementation TTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目设置";
    [self getProjectMemberList];
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

#pragma mark - UITableViewDataSource && Delegate
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
            selectCircleVC.selectCircleVCBlock = ^(id selectObject, SelectCircleViewControllerForSetting *selectCircleVC){
                self.project = selectObject;
                [self getProjectMemberList];
            };
            [self.navigationController pushViewController:selectCircleVC animated:YES];
        } else if (type == EProjectGroup) {
            TTSettingGroupViewController *settingGroupVC = [[TTSettingGroupViewController alloc] init];

            [self.navigationController pushViewController:settingGroupVC animated:YES];
        } else if (type == EProjectAddMember){
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
            NSString *subString = [Common encyptWithDictionary:@{@"project_id":self.project.project_id}];
            NSString *composeURL = [NSString stringWithFormat:@"%@?%@",kLinkURL, subString];
            [WXApiRequestHandler sendLinkURL:composeURL
                                     TagName:kLinkTagName
                                       Title:kLinkTitle
                                 Description:kLinkDescription
                                  ThumbImage:thumbImage
                                     InScene:WXSceneSession];
        } else if (type == EProjectDleteProject){
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"确定要删除并退出该项目？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    if (self.project.member_type == 1) {//1代表管理员
                        [self projectDeleteWithProject:self.project];
                    } else {
                        [self projectMemberQuit];
                    }
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
        bgView.backgroundColor = kRGB(21, 27, 38);
        return bgView;
    }
    return nil;
}

#pragma mark - 获取成员列表
- (void)getProjectMemberList {
    ProjectMemberListApi *listApi = [[ProjectMemberListApi alloc] init];
    listApi.requestArgument = @{@"pid":self.project.project_id};
    [listApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getProjectMemberList:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            self.projectMembersArr = [NSMutableArray array];
            for (NSDictionary *membersDic in request.responseJSONObject[OBJ][@"members"]) {
                TT_Project_Members *projectMember = [[TT_Project_Members alloc] init];
                [projectMember setValuesForKeysWithDictionary:membersDic];
                [self.projectMembersArr addObject:projectMember];
            }
            self.dataSource = @[
                                @{@"Type":@0,
                                  @"Name":@"项目",
                                  @"Description":self.project.name,
                                  @"ShowAccessory":@1,
                                  @"IsEdit":@0,
                                  @"Color":kRGB(27.0, 41.0, 58.0)},
                                @{@"Type":@1,
                                  @"Name":@"组",
                                  @"Description":self.project.group_name,
                                  @"ShowAccessory":@1,
                                  @"IsEdit":@0,
                                  @"Color":kRGB(27.0, 41.0, 58.0)},
                                @{@"Type":@2,
                                  @"Name":@"项目成员",
                                  @"Description":@"",
                                  @"ShowAccessory":@0,
                                  @"IsEdit":@0,
                                  @"Color":kRGB(27.0, 41.0, 58.0),
                                  @"Members":self.projectMembersArr},
                                @{@"Type":@3,
                                  @"Name":@"",
                                  @"Description":@"",
                                  @"ShowAccessory":@0,
                                  @"IsEdit":@0,
                                  @"Color":[UIColor clearColor]}].mutableCopy;
            
            [self.contentTable reloadData];
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 退出项目
- (void)projectMemberQuit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ProjectMemberQuitApi *api = [[ProjectMemberQuitApi alloc] init];
    api.requestArgument = @{@"pid":self.project.project_id};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectMemberQuitApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (self.requestData) {
                self.requestData();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectMemberQuitApi:%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
}

#pragma mark - 项目删除
- (void)projectDeleteWithProject:(TT_Project *)project {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ProjectDeleteApi *projectDeleteApi = [[ProjectDeleteApi alloc] init];
    projectDeleteApi.requestArgument = @{@"pid":project.project_id};
    [projectDeleteApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectDeleteApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (self.requestData) {
                self.requestData();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
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
