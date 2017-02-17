//
//  TTProjectsMenuViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTProjectsMenuViewController.h"
#import "IQKeyboardManager.h"
#import "MockDatas.h"
#import "GroupHeadView.h"
#import "ProjectsCell.h"
#import "ProjectsView.h"
#import "DiVideGroupCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYAdd.h"
#import "TTMyProfileViewController.h"
#import "TTAddProjectViewController.h"
#import "GroupView.h"
#import "SelectGroupView.h"
#import "UIViewController+MMDrawerController.h"
#import "TTSettingViewController.h"
#import "NSString+YYAdd.h"
#import "ProjectItemView.h"
#import "STPushView.h"
#import "TTBaseViewController+NotificationHandle.h"

typedef enum{
    RTSnapshotMeetsEdgeTop,
    RTSnapshotMeetsEdgeBottom,
}RTSnapshotMeetsEdge;

@interface TTProjectsMenuViewController ()

@property(nonatomic,strong)ProjectsView *pView;

@property(nonatomic,strong)GroupView *gView;

@property(nonatomic,strong)SelectGroupView *sgView;

@property (strong, nonatomic) NSMutableArray *unGroupProjects;

@property(nonatomic, strong) NSMutableArray *groups;

@property (strong, nonatomic) NSMutableArray *touchPoints;

@property (strong, nonatomic) NSMutableArray *viewFrames;


/**cell被拖动到边缘后开启，tableview自动向上或向下滚动*/
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
/**自动滚动的方向*/
@property (nonatomic, assign) RTSnapshotMeetsEdge autoScrollDirection;
/**对被选中的cell的截图*/
@property (nonatomic, weak) UIView *snapshot;

@property (assign, nonatomic) BOOL isIntoUserInfo;


@end

@implementation TTProjectsMenuViewController

#pragma mark - Getters
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (NSMutableArray *)viewFrames {
    if (!_viewFrames) {
        _viewFrames = [NSMutableArray array];
    }
    return _viewFrames;
}

- (NSMutableArray *)touchPoints {
    if (_touchPoints == nil) {
        _touchPoints = [NSMutableArray array];
    }
    return _touchPoints;
}

- (NSMutableArray *)unGroupProjects {
    if (_unGroupProjects == nil) {
        _unGroupProjects = [NSMutableArray array];
    }
    return _unGroupProjects;
}

- (ProjectsView *)pView {
    if (!_pView) {
        _pView = [[ProjectsView alloc] initWithDatas:[NSArray array]];
        WeakSelf;
        //data handle
        _pView.projectBlock = ^(ProjectsView *tmpView, id object){
            [wself.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                if (finished) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_NEED_REFRESH_MOMENTS object:[object group_id] userInfo:@{@"Title":[object group_name], @"IsGroup":@1}];
                }
            }];
        };
        //创建分组
        _pView.addProjectBlock = ^(ProjectsView *tmpView){
            [wself creatGroupAction];
        };
        //长按删除分组
        _pView.longPressBlock = ^(UIView *tmpView, id object) {
            //            [wself.menuTable reloadData];
            //            [wself groupDeleteWithGroup:object];
        };
        
    }
    return _pView;
}

- (GroupView *)gView {
    if (!_gView) {
        _gView = LoadFromNib(@"GroupView");
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_gView];
        [_gView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(Screen_Height);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
    }
    return _gView;
}

- (SelectGroupView *)sgView {
    if (!_sgView) {
        _sgView = LoadFromNib(@"SelectGroupView");
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_sgView];
        [_sgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(Screen_Height);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
    }
    return _sgView;
}


/**
 *  创建定时器并运行
 */
- (void)startAutoScrollTimer{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll)];
        [_autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
/**
 *  停止定时器并销毁
 */
- (void)stopAutoScrollTimer{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

/**
 *  检查截图是否到达边缘，并作出响应
 */
- (BOOL)checkIfSnapshotMeetsEdge{
    CGFloat minY = CGRectGetMinY(_snapshot.frame);
    CGFloat maxY = CGRectGetMaxY(_snapshot.frame);
    if (minY < self.menuTable.contentOffset.y) {
        _autoScrollDirection = RTSnapshotMeetsEdgeTop;
        return YES;
    }
    if (maxY > self.menuTable.bounds.size.height + self.menuTable.contentOffset.y) {
        _autoScrollDirection = RTSnapshotMeetsEdgeBottom;
        return YES;
    }
    return NO;
}


/**
 *  开始自动滚动
 */
- (void)startAutoScroll{
    CGFloat pixelSpeed = 4;
    CGFloat y =  self.menuTable.contentOffset.y;
    if (_autoScrollDirection == RTSnapshotMeetsEdgeTop) {//向下滚动
        if (y > 0) {//向下滚动最大范围限制
            [self.menuTable setContentOffset:CGPointMake(0, y - pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - pixelSpeed);
        }
    }else{                                               //向上滚动
        if (y + self.menuTable.bounds.size.height < self.menuTable.contentSize.height) {//向下滚动最大范围限制
            [self.menuTable setContentOffset:CGPointMake(0, y + pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + pixelSpeed);
        }
    }
    
    /*  当把截图拖动到边缘，开始自动滚动，如果这时手指完全不动，则不会触发‘UIGestureRecognizerStateChanged’，对应的代码就不会执行，导致虽然截图在tableView中的位置变了，但并没有移动那个隐藏的cell，用下面代码可解决此问题，cell会随着截图的移动而移动
     */
//    _relocatedIndexPath = [self indexPathForRowAtPoint:_snapshot.center];
//    if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
//        [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
    self.view.backgroundColor = [Common colorFromHexRGB:@"151b27"];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [Common removeExtraCellLines:self.menuTable];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [Common colorFromHexRGB:@"151b27"];
    self.menuTable.backgroundView = v;
    self.menuTable.backgroundColor = [Common colorFromHexRGB:@"151b27"];
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan)];
    edgePan.edges = UIRectEdgeRight;
    [self.menuTable addGestureRecognizer:edgePan];
    
    //处理通知
    [self handleNotificationWithBlock:^(id notification) {
        if (notification) {
            if ([notification isKindOfClass:[TT_Message class]]) {
                TT_Message *message = (TT_Message *)notification;
                if (message.message_type == 1 ||
                    message.message_type == 3) {
                    //1.发请求
                    //2.刷新UI
                    [self getAllGroupsAndProjectsData];
                }
            }
        }
    }];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeCustomObserver:self Name:NOTICE_KEY_MESSAGE_COMING Object:nil];
}

- (void)handleScreenEdgePan {
    [UIView animateWithDuration:0.5 animations:^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (!self.isIntoUserInfo) {
        [self getAllGroupsAndProjectsData];
    } else {
        self.isIntoUserInfo = NO;
    }
    //fix a bug
    self.menuTable.contentInset = UIEdgeInsetsMake(0, 0, 5.0, 0);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)loadUserInfo {
    NSDictionary *dic = [MockDatas testerInfo];
    self.nameLab.text = dic[@"Name"];
    self.remarkLab.text = dic[@"Remarks"];
    if (![Common isEmptyString:dic[@"HeadImage"]]) {
        NSString *urlString = [Common handleWeChatHeadImageUrl:dic[@"HeadImage"] Size:132];
        NSURL *url = [NSURL URLWithString:urlString];
        [self.headImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"common-headDefault"] options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            image = [image imageByRoundCornerRadius:66];
            self.headImgV.image = image;
        }];
    }
}


#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 1) {
        return self.unGroupProjects.count;
    }
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section > 1) {
        static NSString *cellID = @"CellIdentifyProject";
        cell = (ProjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = LoadFromNib(@"ProjectsCell");
        }
        cell.tag = indexPath.section * 1000  + indexPath.row;
        TT_Project *projectInfo = self.unGroupProjects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.unGroupProjects.count - 1];
        
        //长按手势
        //        if (![Common isEmptyArr:self.groups]) {
        //            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        //            [(ProjectsCell *)cell addGestureRecognizer:longPress];
        //        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.6;
        [(ProjectsCell *)cell addGestureRecognizer:longPress];
        
        
        MGSwipeButton *deleteBtn = [MGSwipeButton buttonWithTitle:@"" icon:kImage(@"icon_delete") backgroundColor:kRGB(39, 58, 80) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目?" buttonTitles:@[@"取消", @"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSLog(@"删除项目");
                    if (projectInfo.member_type == 1) {
                        [self projectDeleteWithProject:projectInfo];
                    } else {
                        [self projectMemberQuitWithProject:projectInfo];
                    }
                    
                }
            }];
            return YES;
        }];
        MGSwipeButton *topBtn = [MGSwipeButton buttonWithTitle:@"" icon:kImage(@"icon_top") backgroundColor:kRGB(39, 58, 80) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            BOOL srcTop = projectInfo.isTop;
            projectInfo.isTop = !projectInfo.isTop;
            [self projectTopWithProject:projectInfo SrcTop:srcTop];
            return YES;
        }];
        MGSwipeButton *notDisturbBtn = [MGSwipeButton buttonWithTitle:@"" icon:kImage(@"icon_do_not_disturb")  backgroundColor:kRGB(39, 58, 80) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            projectInfo.isNoDisturb = !projectInfo.isNoDisturb;
            [self projectDisturbWithProject:projectInfo];
            return YES;
        }];
        ((ProjectsCell *)cell).rightButtons = @[deleteBtn, topBtn, notDisturbBtn];
        ((ProjectsCell *)cell).rightSwipeSettings.transition = MGSwipeTransitionStatic;
    }else {
        if (indexPath.section == 0) {
            static NSString *cellID = @"CellIdentify";
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.backgroundColor = [Common colorFromHexRGB:@"151b27"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell addSubview:self.infoView];
            [self loadUserInfo];
            [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left);
                make.right.mas_equalTo(cell.mas_right);
                make.top.mas_equalTo(cell.mas_top);
                make.bottom.mas_equalTo(cell.mas_bottom).offset(minLineWidth);
            }];
        } else {
            cell = [DiVideGroupCell cellWithTableView:tableView];
            
            [((DiVideGroupCell *)cell).dataSource removeAllObjects];
            [((DiVideGroupCell *)cell).dataSource addObjectsFromArray:self.groups];
            [((DiVideGroupCell *)cell).collectionView reloadData];
            //点击分组进入moments
            ((DiVideGroupCell *)cell).clickGroupBlock = ^(TT_Group *tempGroup) {
                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_NEED_REFRESH_MOMENTS object:tempGroup userInfo:@{@"Title":[tempGroup group_name], @"IsGroup":@1}];
                    }
                }];
            };
            //创建分组
            ((DiVideGroupCell *)cell).clickAddGroupBlock = ^() {
                [self creatGroupAction];
            };
            //长按
            //            ((DiVideGroupCell *)cell).longPressItemBlock = ^() {
            //                TT_Group *group = self.groups[indexPath.row];
            //                [self groupDeleteWithGroup:group];
            //            };
            //删除分组
            ((DiVideGroupCell *)cell).clickDeleteBtnBlock = ^(TT_Group *tmpGroup) {
                [self groupDeleteWithGroup:tmpGroup];
            };
            
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return minLineWidth;
    }else if (section == 1) {
        return 40;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return minLineWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    GroupHeadView *headView = LoadFromNib(@"GroupHeadView");
    if (section >= 1) {
        headView.isEnabledSwipe = NO;
        [headView loadHeadViewIndex:section projectCount:self.unGroupProjects.count];
    }
    headView.addProjectBlock = ^() {
        TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
        [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addProfileVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
    };
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return CELLHEIGHT;
    } else if (indexPath.section == 0) {
        return 120.0;
    } else {
        return [DiVideGroupCell heightOfProjectsView:self.groups] + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell && [cell isKindOfClass:[ProjectsCell class]]) {
            ((ProjectsCell *)cell).backgroundColor = [Common colorFromHexRGB:@"1c293b"];
            [UIView animateWithDuration:0.3 animations:^{
                ((ProjectsCell *)cell).backgroundColor = [UIColor clearColor];
             
            }];
        }
        //主页moments
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                NSString *Id = self.unGroupProjects[indexPath.row];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_NEED_REFRESH_MOMENTS object:Id userInfo:@{@"Title":[self.unGroupProjects[indexPath.row] name], @"ISGROUP":@0}];
            }
        }];
    }
}

#pragma mark - 个人设置
- (IBAction)clickHeadInfoAction:(id)sender {
    TTMyProfileViewController *myProfileVC = [[TTMyProfileViewController alloc] init];
    self.isIntoUserInfo = YES;
    [self.navigationController pushViewController:myProfileVC animated:YES];
}

#pragma mark - 首页
- (IBAction)clickHomeAction:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_NEED_REFRESH_MOMENTS object:nil userInfo:@{@"Title":@"Moments", @"ISGROUP":@0}];
    }];
}

#pragma mark - 请求数据
- (void)getAllGroupsAndProjectsData {
    [[CirclesManager sharedInstance].views removeAllObjects];
    AllGroupsApi *groupsApi = [[AllGroupsApi alloc] init];
    [groupsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"AllGroupsApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic =  request.responseJSONObject[OBJ];
            //分组数据
            if (![Common isEmptyArr:self.groups]) {
                [self.groups removeAllObjects];
            }
            NSArray *groupArray = objDic[@"groups"];
            for (NSDictionary *groupDic in groupArray) {
                TT_Group *group = [[TT_Group alloc] init];
                group.group_id = groupDic[@"_id"];
                group.group_name = groupDic[@"group_name"];
                group.project_nums = [groupDic[@"project_nums"] integerValue];
                group.newscount = [groupDic[@"newscount"] integerValue];
                [self.groups addObject:group];
            }
            
            //未分组项目
            if (![Common isEmptyArr:self.unGroupProjects]) {
                [self.unGroupProjects removeAllObjects];
            }
            NSArray *projectsArray = objDic[@"projects"];
            for (NSDictionary *projectDic in projectsArray) {
                TT_Project *project = [[TT_Project alloc] init];
                [project setValuesForKeysWithDictionary:projectDic];
                [self.unGroupProjects addObject:project];
            }
            [self.menuTable reloadData];
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"getAllGroups:%@", error);
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
            [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
            [self.unGroupProjects removeObject:project];
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 退出项目
- (void)projectMemberQuitWithProject:(TT_Project *)project {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ProjectMemberQuitApi *api = [[ProjectMemberQuitApi alloc] init];
    api.requestArgument = @{@"pid":project.project_id};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectMemberQuitApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
            [self.unGroupProjects removeObject:project];
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectMemberQuitApi:%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
}

#pragma mark - 项目置顶
- (void)projectTopWithProject:(TT_Project *)project SrcTop:(BOOL) srcTop{
    NSNumber *position = project.isTop ? @2 : @1;
    ProjectTopApi *projectTopApi = [[ProjectTopApi alloc] init];
    projectTopApi.requestArgument = @{@"pid":project.project_id,
                                      @"position":position};
    [projectTopApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectDeleteApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self getAllGroupsAndProjectsData];
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
            project.isTop = srcTop;
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        project.isTop = srcTop;
        [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 免打扰
- (void)projectDisturbWithProject:(TT_Project *)project {
    NSNumber *isDisturb = [NSNumber numberWithBool:project.isNoDisturb];
    ProjectDisturbApi *projectDisturbApi = [[ProjectDisturbApi alloc] init];
    projectDisturbApi.requestArgument = @{@"pid":project.project_id,
                                          @"isDisturb":isDisturb};
    [projectDisturbApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectDisturbApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectDisturbApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 删除分组
- (void)groupDeleteWithGroup:(TT_Group *)group {
    GroupDeleteApi *groupDeleteApi = [[GroupDeleteApi alloc] init];
    groupDeleteApi.requestArgument = @{@"gid":group.group_id};
    [groupDeleteApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"GroupDeleteApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self.groups removeObject:group];
            [self.menuTable reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"GroupDeleteApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 创建分组
- (void)creatGroupAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:self.unGroupProjects];
        [self.gView show];
        WeakSelf;
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                [super showHudWithText:@"正在创建..."];
                NSArray *pids = [object[@"Pids"] componentsSeparatedByString:@","];
                NSData *data = [NSJSONSerialization dataWithJSONObject:pids options:NSJSONWritingPrettyPrinted error:nil];
                NSString *strPids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                GroupCreatApi *groupCreatApi = [[GroupCreatApi alloc] init];
                groupCreatApi.requestArgument = @{@"group_name":object[@"Name"],
                                                  @"pids":strPids};
                [groupCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    NSLog(@"creatGroupAction:%@", request.responseJSONObject);
                    [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
                    if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
                        [wself getAllGroupsAndProjectsData];
                    }
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    NSLog(@"%@", error);
                    [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
                }];
            }
        };
    }
}

#pragma mark - 移动项目
- (void)moveProjectTo_group:(TT_Group *)group project:(TT_Project *)project {
    MoveProjectApi *moveProjectApi = [[MoveProjectApi alloc] init];
    moveProjectApi.requestArgument = @{@"to_gid":group.group_id,
                                       @"pid":[project project_id]};//pid 项目id
    [moveProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"moveProject:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [[CirclesManager sharedInstance].views removeAllObjects];
            [super showText:[NSString stringWithFormat:@"项目已添加至%@分组", group.group_name] afterSeconds:2.0];
            [self getAllGroupsAndProjectsData];
        }else {
            [super showText:@"项目已存在该分组下" afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"moveProject:%@", error);
        if (error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }
    }];
}

#pragma mark - 长按手势方法
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    [self getViewFrames];
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.menuTable];
    NSIndexPath *indexPath = [self.menuTable indexPathForRowAtPoint:location];
    TT_Project *project = [self.unGroupProjects objectAtIndex:indexPath.row];
    
    static UIView *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    switch (state) {
            // 开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                //1.创建cell快照
                UITableViewCell *cell = [self.menuTable cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshoFromView:cell];
                _snapshot = snapshot;
                //2.添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.menuTable addSubview:snapshot];
                //3.让快照跟着手指移动
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    snapshot.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            if ([self checkIfSnapshotMeetsEdge]) {
                [self startAutoScrollTimer];
            }else{
                [self stopAutoScrollTimer];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self stopAutoScrollTimer];
            // 清空数组，非常重要，不然会发生坐标突变！
            [self.touchPoints removeAllObjects];
            UITableViewCell *cell = [self.menuTable cellForRowAtIndexPath:(NSIndexPath  * _Nonnull)indexPath];
            for (NSValue *frameValue in self.viewFrames) {
                BOOL isContain =  CGRectContainsPoint([frameValue CGRectValue], location);
                if (isContain) {
                    //1.取出下标
                    NSUInteger index =  [self.viewFrames indexOfObject:frameValue];
                    NSLog(@"index:%lu---%ld", index, self.viewFrames.count);
                    // 将快照放到分组里面
                    [UIView animateWithDuration:0.5 animations:^{
                        snapshot.transform = CGAffineTransformMakeScale(0.3, 1.4);
                    } completion:^(BOOL finished) {
                        [snapshot removeFromSuperview];
                        snapshot = nil;
                    }];
                    //2.取出对应的模型
                    TT_Group *group = self.groups[index];
                    //3.移动分组
                    [self moveProjectTo_group:group project:project];
                }else {
                    cell.hidden = NO;
                    // 将快照恢复到初始状态
                    [UIView animateWithDuration:0.25 animations:^{
                        snapshot.center = cell.center;
                        snapshot.transform = CGAffineTransformIdentity;
                        snapshot.alpha = 0.0;
                        cell.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        [snapshot removeFromSuperview];
                        snapshot = nil;
                    }];
                }
            }
            
                cell.hidden = NO;
                [self.menuTable reloadData];
                // 将快照恢复到初始状态
                [UIView animateWithDuration:0.25 animations:^{
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    
                }];
            
            
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            UITableViewCell *cell = [self.menuTable cellForRowAtIndexPath:(NSIndexPath  * _Nonnull)indexPath];
            cell.hidden = NO;
            [self.menuTable reloadData];
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
        default: {
            break;
        }
    }
    
}

#pragma mark - 创建cell的快照
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (void)getViewFrames {
    [self.viewFrames removeAllObjects];
    int count = (int)[CirclesManager sharedInstance].views.count;
    for (int i = 0; i < count; i++) {
        UIView *tmpView = [CirclesManager sharedInstance].views[i];
        CGRect viewF =  [self.menuTable convertRect:tmpView.frame fromView:tmpView.superview];
        [self.viewFrames addObject:[NSValue valueWithCGRect:viewF]];
    }
    NSLog(@"view:%d---viewFrames:%ld", count, self.viewFrames.count);
}

@end
