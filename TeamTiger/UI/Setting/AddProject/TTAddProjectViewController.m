//
//  TTSettingViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/27.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "Constant.h"
#import "IQKeyboardManager.h"
#import "SettingCell.h"
#import "TTAddContactorViewController.h"
#import "TTAddProjectViewController.h"
#import "UIAlertView+HYBHelperKit.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "AFNetworking.h"

@interface TTAddProjectViewController ()<WXApiManagerDelegate>{
     NSString *_name;
     NSString *_des;
     BOOL isPrivate;
}

@end

@implementation TTAddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建项目";
    [Common removeExtraCellLines:self.contentTable];
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;

    self.contentTable.estimatedRowHeight = 77;
    self.contentTable.rowHeight = UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellIdentify";
    NSDictionary *dic = self.datas[indexPath.section];
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [SettingCell loadCellWithData:dic];
    }
    [cell reloadCell:dic];
    cell.actionBlock = ^(SettingCell *settingCell, ECellType type, id obj){
        switch (type) {
            case ECellTypeTextField:{
                _name = obj;
                break;
            }
            case ECellTypeTextView:{
                _des = obj;
                break;
            }
            case ECellTypeSwitch:{
                isPrivate = (BOOL)obj;
                break;
            }
            case ECellTypeAccessory:{
//                NSLog(@"跳转微信，增加人员");
//                UIImage *thumbImage = [UIImage imageNamed:@"2.png"];
//                [WXApiRequestHandler sendLinkURL:kLinkURL
//                                         TagName:kLinkTagName
//                                           Title:kLinkTitle
//                                     Description:kLinkDescription
//                                      ThumbImage:thumbImage
//                                         InScene:WXSceneSession];
                
                TTAddContactorViewController *addContactorVC = [[TTAddContactorViewController alloc] initWithNibName:@"TTAddContactorViewController" bundle:nil];
                [self.navigationController pushViewController:addContactorVC animated:YES];
                break;
            }
            case ECellTypeBottom:{
                [self createProjectWith:@"工作牛"description:@"项目讨论" is_private:isPrivate];
                break;
            }
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)createProjectWith:(NSString *)name description:(NSString *)description is_private:(BOOL)is_private {
   
    
    if ([Common isEmptyString:name] || [Common isEmptyString:description]) {
        [self showHudWithText:@"名称或描述不能为空"];
        [self hideHudAfterSeconds:3.0];
        return;
    }
#warning TO DO.....
    ProjectCreateApi *projectCreateApi = [[ProjectCreateApi alloc] init];
    projectCreateApi.requestArgument = @{@"name":name,
                                         @"description":description,
                                         @"is_private":@(is_private),
                                         @"current_state":@(0),
                                         @"is_allow_delete":@(NO)
                                         };
    [projectCreateApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            //创建失败
            [super showHudWithText:request.responseJSONObject[MSG]];
            [super hideHudAfterSeconds:3.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma -mark getters
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithObjects:
                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"名称",@"TYPE":@"0"},
                  @{@"NAME":@"ffgfgfgfgfgfgfggf大大大大大大大大大大大大",@"TITLE":@"描述",@"TYPE":@"1"},
                  @{@"NAME":@"飞凤飞飞如果认购人跟人沟通",@"TITLE":@"私有",@"TYPE":@"2"},
                  @{@"NAME":@"个体户头昏眼花与银行业和银行业和银行业测试",@"TITLE":@"添加成员",@"TYPE":@"3"},
                  @{@"NAME":@"",@"TITLE":@"",@"TYPE":@"4"},nil];
    }
    return _datas;
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
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
}

@end
