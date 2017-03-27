//
//  TTAddMemberViewController.m
//  TeamTiger
//
//  Created by Dale on 17/2/3.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTAddMemberViewController.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "TTAddMemberCell.h"

@interface TTAddMemberViewController () <UITableViewDataSource, UITableViewDelegate, WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *membersArray;//与我有关系的成员数组
@property (strong, nonatomic) NSMutableArray *selectMembers;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation TTAddMemberViewController

#pragma mark - getter 
- (NSMutableArray *)membersArray {
    if (_membersArray == nil) {
        _membersArray = [NSMutableArray array];
    }
    return _membersArray;
}

- (NSMutableArray *)selectMembers {
    if (_selectMembers == nil) {
        _selectMembers = [NSMutableArray array];
    }
    return _selectMembers;
}

- (NSMutableArray *)members {
    if (_members == nil) {
        _members = [NSMutableArray array];
    }
    return _members;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationItem];
    self.view.backgroundColor = kColorForBackgroud;
    self.tableView.backgroundColor = kColorForBackgroud;
    [self userRelation];
    [WXApiManager sharedManager].delegate = self;
    self.tableView.rowHeight = 70;
    [Common removeExtraCellLines:self.tableView];
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"添加成员";
    //左侧
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    rightBtn.hidden = YES;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void)handleRightBtnAction {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.selectMembers options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ProjectMemberInviteApi *api = [[ProjectMemberInviteApi alloc] init];
    api.requestArgument = @{@"pid":self.project.project_id,
                            @"uids":memberStr};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectMemberInviteApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] integerValue] == 1) {
            if (self.addMemberBlock) {
                self.addMemberBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectMemberInviteApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.membersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TT_Project_Members *member = self.membersArray[indexPath.row];
    
    static NSString *ID = @"TTAddMemberCell";
    TTAddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        if ([Common isEmptyString:member.user_id]) {
            cell = LoadFromNib(@"TTAddMemberCell2");
        } else {
            cell = LoadFromNib(@"TTAddMemberCell");
        }
        cell.contentView.backgroundColor = kRGB(27, 42, 58);
    }
    cell.icon_confirm.hidden = !member.isSelect;
    cell.user = member;
    [cell setSelectBtnBlock:^(TTAddMemberCellType type){
        if (type == TTAddMemberCellTypeSelectMember) {
            member.isSelect = !member.isSelect;
            [self.tableView reloadData];
            if (member.isSelect) {
                [self.selectMembers addObject:member.user_id];
            } else {
                [self.selectMembers removeObject:member.user_id];
            }
            if ([Common isEmptyArr:self.selectMembers]) {
                self.rightBtn.hidden = YES;
            } else {
                self.rightBtn.hidden = NO;
            }
        } else {
             [self toWeChatAddMember];
        }
        
    }];
    
    return cell;
}


- (void)toWeChatAddMember {
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
    TT_User *user = [TT_User sharedInstance];
    NSString *nick_name = user.nickname;
    NSString *current_time = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *subString = [Common encypt2StrWithDictionary:@{@"project_id":self.project.project_id,
                                                         @"project_name":self.project.name,
                                                         @"nick_name":nick_name,
                                                         @"current_time":current_time}UnencyptKeys:@[@"project_name",@"nick_name",@"current_time"] Mode:0];
    NSString *composeURL = [NSString stringWithFormat:@"%@?%@",kLinkURL, subString];
    composeURL = [composeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [WXApiRequestHandler sendLinkURL:composeURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:WXSceneSession];
}

#pragma mark - 获取与当前用户存在项目关系的用户
- (void)userRelation{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserRelationApi *api = [[UserRelationApi alloc] init];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"UserRelationApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *response = request.responseJSONObject[OBJ];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:response[@"members"]]) {
                for (NSDictionary *membersDic in response[@"members"]) {
                    TT_Project_Members *member = [[TT_Project_Members alloc] init];
                    member.user_name = membersDic[@"nick_name"];
                    member.user_img_url = [Common handleWeChatHeadImageUrl:membersDic[@"head_img_url"] Size:132];
                    member.user_id = membersDic[@"uid"];
                    [self.membersArray addObject:member];
                }
                [self.membersArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    TT_Project_Members *tempUser1 = (TT_Project_Members *)obj1;
                    TT_Project_Members *tempUser2 = (TT_Project_Members *)obj2;
                    return [[tempUser1.user_name pinyin] compare:[tempUser2.user_name pinyin]];
                }];
                
                NSMutableArray *tempArr = [self.membersArray mutableCopy];
                for (TT_Project_Members *member in self.members) {
                    for (TT_Project_Members *tempMembers in tempArr) {
                        if ([member.user_name isEqualToString:tempMembers.user_name]) {
                            [self.membersArray removeObject:tempMembers];
                        }
                    }
                }
                
                TT_Project_Members *user = [[TT_Project_Members alloc] init];
                user.user_name = @"让微信朋友通过连接加入项目";
                [self.membersArray addObject:user];
            } else {
                TT_Project_Members *user = [[TT_Project_Members alloc] init];
                user.user_name = @"让微信朋友通过连接加入项目";
                [self.membersArray addObject:user];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"UserRelationApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
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
