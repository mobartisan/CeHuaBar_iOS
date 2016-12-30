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
#import "TTAddProjectViewController.h"
#import "UIAlertView+HYBHelperKit.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "AFNetworking.h"
#import "CirclesManager.h"


@interface TTAddProjectViewController ()<WXApiManagerDelegate>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *project_id;

@end

@implementation TTAddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加项目";
    [Common removeExtraCellLines:self.contentTable];
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加成员" forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(0, 0, 80, 30);
    [addBtn addTarget:self action:@selector(handleAddMember) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;
    
    self.contentTable.estimatedRowHeight = 77;
    self.contentTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)handleAddMember {
    NSLog(@"跳转微信，增加人员");
    if ([Common isEmptyString:self.project_id]) {
        [super showText:@"请先添加项目" afterSeconds:1.5];
        return;
    }
    UIImage *thumbImage = [UIImage imageNamed:@"AppIcon"];
    //              方式一:
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
    //              方式二:
    
    //                NSString *urlString = @"http://101.200.138.176:9080/test.html";
    
    NSString *subString = [Common encyptWithDictionary:@{@"project_id":self.project_id}];
    NSString *composeURL = [NSString stringWithFormat:@"%@?%@",kLinkURL, subString];
    [WXApiRequestHandler sendLinkURL:composeURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:WXSceneSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentTable endEditing:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
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
                self.name = obj;
                break;
            }
            case ECellTypeSwitch:{
                break;
            }
            case ECellTypeAccessory:{
                [self handleAddMember];
                break;
            }
            case ECellTypeBottom:{
                [self createProjectWithProjectName:self.name];
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

#pragma mark 创建项目
- (void)createProjectWithProjectName:(NSString *)name {
    if ([Common isEmptyString:name]) {
        [self showHudWithText:@"项目名称不能为空"];
        [self hideHudAfterSeconds:1.0];
        return;
    }
    ProjectCreateApi *projectCreateApi = [[ProjectCreateApi alloc] init];
    projectCreateApi.requestArgument = @{@"name":name,
                                         @"uids":@"",//假设项目中有可以添加的成员,如果有,uids表示所有成员的@{@"NAME":@"个体户头昏眼花与银行业和银行业和银行业测试",@"TITLE":@"添加成员",@"TYPE":@"3"},没有的话给空
                                         };
    [projectCreateApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectCreateApi:%@", request.responseJSONObject);
        [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            self.project_id = @"测试ID";
            [self.datas removeObjectAtIndex:1];
            [self.contentTable reloadData];
            [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectCreateApi:%@",error.description);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma -mark getters
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithObjects:
                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"项目名称:",@"TYPE":@"0"},
                  //                  @{@"NAME":@"ffgfgfgfgfgfgfggf大大大大大大大大大大大大",@"TITLE":@"描述",@"TYPE":@"1"},
                  //                  @{@"NAME":@"飞凤飞飞如果认购人跟人沟通",@"TITLE":@"私有",@"TYPE":@"2"},
//                  @{@"NAME":@"个体户头昏眼花与银行业和银行业和银行业测试",@"TITLE":@"添加成员",@"TYPE":@"3"},
                  @{@"NAME":@"",@"TITLE":@"",@"TYPE":@"4"},nil];
    }
    return _datas;
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
    NSLog(@"%@--%@", response.lang, response.country);
    [self.contentTable endEditing:YES];
    if (self.requestData) {
        self.requestData();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
}

@end
