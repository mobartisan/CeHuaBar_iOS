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
#import "UIImageView+WebCache.h"
#import "UIImage+YYAdd.h"
#import "TTMyProfileViewController.h"
#import "TTAddProjectViewController.h"
#import "GroupView.h"
#import "SelectGroupView.h"
#import "UIViewController+MMDrawerController.h"
#import "TTSettingViewController.h"
#import "TTGroupViewController.h"
#import "NSString+YYAdd.h"

@interface TTProjectsMenuViewController ()

@property(nonatomic,strong)ProjectsView *pView;

@property(nonatomic,strong)GroupView *gView;

@property(nonatomic,strong)SelectGroupView *sgView;

@property (strong, nonatomic) NSString *unGroup_id;

@end

@implementation TTProjectsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllGroups];
    self.view.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [Common removeExtraCellLines:self.menuTable];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
    self.menuTable.backgroundView = v;
    self.menuTable.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
}

#warning to do 获取所有分组
- (void)getAllGroups {
    AllGroupsApi *groupsApi = [[AllGroupsApi alloc] init];
    [groupsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getAllGroups:%@", request.responseJSONObject);
        
        //分组数据
        if (![Common isEmptyArr:self.groups]) {
            [self.groups removeAllObjects];
        }
        NSDictionary *objDic =  request.responseJSONObject[OBJ];
        for (NSDictionary *existlistDic in objDic[@"existlist"]) {
            TT_Group *group = [[TT_Group alloc] init];
            group.group_id = existlistDic[@"_id"];
            group.group_name = existlistDic[@"group_name"];
            group.create_date = existlistDic[@"group_create_date"];
            [self.groups addObject:group];
        }
        
        //未分组
        if (![Common isEmptyArr:self.unGroupedProjects]) {
            [self.unGroupedProjects removeAllObjects];
        }
        NSDictionary *noexistlistDic = [objDic[@"noexistlist"] firstObject];
        self.unGroup_id = noexistlistDic[@"_id"];
        if ([(noexistlistDic[@"pids"]) count] > 0) {
            for (NSDictionary *pidsDic in noexistlistDic[@"pids"]) {
                TT_Project *project = [[TT_Project alloc] init];
                project.project_id = pidsDic[@"_id"];
                project.name = pidsDic[@"name"];
                [self.unGroupedProjects addObject:project];
            }
        }
        
        [self.menuTable reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"getAllGroups:%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getAllGroups];
    [self.menuTable reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 1) {
        return self.unGroupedProjects.count;
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
        TT_Project *projectInfo = self.unGroupedProjects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.unGroupedProjects.count - 1];
        
        __weak typeof(cell) tempCell = cell;
        //设置删除cell回调block
        ((ProjectsCell *)cell).deleteMember = ^{
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"未分组的项目无法移出分组" buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {}];
        };
        //增加项目至分组的cell回调block
        ((ProjectsCell *)cell).addMember = ^{
            [self addProjectIntoGroupAction:projectInfo];
        };
        //设置当cell左滑时，关闭其他cell的左滑
        ((ProjectsCell *)cell).closeOtherCellSwipe = ^{
            for (ProjectsCell *item in tableView.visibleCells) {
                if ([item isKindOfClass:[ProjectsCell class]] && item != tempCell) {
                    [item closeLeftSwipe];
                }
            }
        };
    }
    else {
        static NSString *cellID = @"CellIdentify";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0) {
            [cell addSubview:self.infoView];
            [self loadUserInfo];
            [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left);
                make.right.mas_equalTo(cell.mas_right);
                make.top.mas_equalTo(cell.mas_top);
                make.bottom.mas_equalTo(cell.mas_bottom).offset(minLineWidth);
            }];
        } else {
            [cell addSubview:self.pView];
            [self.pView loadGroupsInfos:self.groups];
            [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell);
            }];
        }
    }
    return cell;
}

#warning 移动未分组项目到某个分组下
- (void)moveProjectFrom_gid:(NSString *)from_gid to_gid:(NSString *)to_gid pid:(NSString *)pid {
    MoveProjectApi *moveProjectApi = [[MoveProjectApi alloc] init];
    moveProjectApi.requestArgument = @{@"from_gid":from_gid,
                                       @"to_gid":to_gid,
                                       @"pid":pid};//pid 项目id
    [moveProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"moveProject:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [super showText:@"项目已添加至该分组" afterSeconds:1];
            [self getAllGroups];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"moveProject:%@", error);
        if (error) {
            [super showText:@"项目添加至该分组失败" afterSeconds:1];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return minLineWidth;
    }
    return 30;
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
        [headView loadHeadViewIndex:section];
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return CELLHEIGHT;
    } else if (indexPath.section == 0) {
        return 120.0;
    } else {
        return [ProjectsView heightOfProjectsView:self.groups] + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ProjectsCell class]]) {
        ((ProjectsCell *)cell).backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        ((ProjectsCell *)cell).containerView.backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        [UIView animateWithDuration:0.3 animations:^{
            ((ProjectsCell *)cell).backgroundColor = [UIColor clearColor];
            ((ProjectsCell *)cell).containerView.backgroundColor = [UIColor clearColor];
        }];
    }
    //主页moments
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        if (finished) {
            NSString *Id = [self.unGroupedProjects[indexPath.row] project_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"Title":[self.unGroupedProjects[indexPath.row] name], @"ISGROUP":@0}];
        }
    }];
}

- (IBAction)clickHeadInfoAction:(id)sender {
    TTMyProfileViewController *myProfileVC = [[TTMyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileVC animated:YES];
}

- (IBAction)clickHomeAction:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:@"" userInfo:@{@"Title":@"Moments", @"ISGROUP":@0}];
    }];
}

#pragma -mark Data Handle
//数据库
/*
- (NSMutableArray *)groups {
    if (!_groups) {
        TT_User *user = [TT_User sharedInstance];
        [SQLITEMANAGER setDataBasePath:user.user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by create_date",TABLE_TT_Group];
        NSArray *groups = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Group];
        _groups = [NSMutableArray arrayWithArray:groups];

    }
    return _groups;
}
*/
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (NSMutableArray *)projects {
    if (!_projects) {
        _projects = [NSMutableArray array];
        for (NSDictionary *projectDic in [CirclesManager sharedInstance].circles) {
            TT_Project *tt_Project = [[TT_Project alloc] init];
            tt_Project.project_id = projectDic[@"_id"];
            tt_Project.name = projectDic[@"name"];
            [_projects addObject:tt_Project];
        }
    }
    return _projects;
}

- (NSMutableArray *)unGroupedProjects {
    if (!_unGroupedProjects) {
        _unGroupedProjects = [NSMutableArray array];
    }
    return _unGroupedProjects;
}

//数据库数据
/*
- (NSMutableArray *)projects {
    if (!_projects) {
        [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by create_date",TABLE_TT_Project];
        NSArray *projects = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Project];
        _projects = [NSMutableArray arrayWithArray:projects];
    }
    return _projects;
}
 
- (NSMutableArray *)unGroupedProjects {
    if (!_unGroupedProjects) {
        [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where is_grouped = 0 order by create_date",TABLE_TT_Project];
        NSArray *ungroupedProjects = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Project];
        _unGroupedProjects = [NSMutableArray arrayWithArray:ungroupedProjects];

    }
    return _unGroupedProjects;
}
 */
//数据库数据
/*
- (void)creatGroupAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:self.projects];
        [self.gView show];
        WeakSelf;
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@",object);
                TT_User *user = [TT_User sharedInstance];
                [SQLITEMANAGER setDataBasePath:user.user_id];
                NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO %@(group_id, name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('%@','%@','%@',null,0,1,datetime('now','localtime'),'%@',datetime('now','localtime'),'%@')",TABLE_TT_Group, object[@"Gid"], object[@"Name"], object[@"Pids"] ,user.user_id, user.user_id];
                [SQLITEMANAGER executeSql:sqlString];
                [wself.groups addObject:[TT_Group creatGroupWithDictionary:object]];
                [wself.menuTable reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                    hud.label.text = @"创建分组成功";
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:1.5];
                });
            }
        };
    }
}
*/

#pragma mark 创建分组...
- (void)creatGroupAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:self.projects];
        [self.gView show];
        WeakSelf;
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@, %@",object[@"Name"], object[@"Pids"]);
                NSArray *pids = [object[@"Pids"] componentsSeparatedByString:@","];
                NSData *data = [NSJSONSerialization dataWithJSONObject:pids options:NSJSONWritingPrettyPrinted error:nil];
                NSString *strPids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                GroupCreatApi *groupCreatApi = [[GroupCreatApi alloc] init];
                groupCreatApi.requestArgument = @{@"group_name":object[@"Name"],
                                                  @"pids":strPids};
                [groupCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    NSLog(@"creatGroupAction:%@", request.requestArgument);
                    [wself getAllGroups];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [super showText:@"创建分组成功" afterSeconds:1.5];
                    });
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    NSLog(@"%@", error);
                    [super showText:@"创建分组失败" afterSeconds:1.5];
                }];
            }
        };
    }
}

#warning to do  未分组项目移动到某个分组
- (void)addProjectIntoGroupAction:(TT_Project *)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:self.groups];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            if (isConfirm) {
                [wself moveProjectFrom_gid:wself.unGroup_id to_gid:[object group_id] pid:projectInfo.project_id];
            }
        };
    }
}
//数据库数据
/*
- (void)addProjectIntoGroupAction:(id)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:self.groups];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            
            if (isConfirm) {
                NSLog(@"%@",object);
                NSMutableArray *pids = [[object pids] componentsSeparatedByString:@","].mutableCopy;
                if([pids containsObject:[projectInfo project_id]]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                        hud.label.text = @"项目已存在该分组";
                        hud.mode = MBProgressHUDModeText;
                        [hud hideAnimated:YES afterDelay:1.5];
                    });
                } else {
                    //添加至分组
                    [pids addObject:[projectInfo project_id]];
                    NSString *nwPids = [pids componentsJoinedByString:@","];
                    NSString *updateSql = [NSString stringWithFormat:@"update %@ set pids = '%@'",TABLE_TT_Group, nwPids];
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    [SQLITEMANAGER executeSql:updateSql];
                    //更改项目状态
                    updateSql = [NSString stringWithFormat:@"update %@ set is_grouped = 1",TABLE_TT_Project];
                    [SQLITEMANAGER executeSql:updateSql];
                    //刷新UI
                    [wself.unGroupedProjects removeObject:projectInfo];
                    [wself.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
                    //给出提示
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                        hud.label.text = @"项目已添加至该分组";
                        hud.mode = MBProgressHUDModeText;
                        [hud hideAnimated:YES afterDelay:1.5];
                    });
                }
            }

        };
    }
}
*/

- (void)loadUserInfo {
    NSDictionary *dic = [MockDatas testerInfo];
    self.nameLab.text = dic[@"Name"];
    self.remarkLab.text = dic[@"Remarks"];
    if (![Common isEmptyString:dic[@"HeadImage"]]) {
        NSString *urlString = dic[@"HeadImage"];
        NSMutableString *mString = [NSMutableString string];
        if ([urlString containsString:@".jpg"] || [urlString containsString:@".png"]) {
            mString = urlString.mutableCopy;
        } else {
            NSArray *components = [urlString componentsSeparatedByString:@"/"];
            NSInteger count = components.count;
            [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != count - 1) {
                    [mString appendFormat:@"%@/",obj];
                } else {
                    [mString appendString:@"132"];//头像大小 46 64 96 132
                }
            }];
        }
        NSURL *url = [NSURL URLWithString:mString];
        [self.headImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"common-headDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            image = [image imageByRoundCornerRadius:66];
            self.headImgV.image = image;
        }];
    }
}

- (ProjectsView *)pView {
    if (!_pView) {
        _pView = [[ProjectsView alloc] initWithDatas:[NSArray array]];
        WeakSelf;
        //data handle
        _pView.projectBlock = ^(ProjectsView *tmpView, id object){
            [wself.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                if (finished) {
                    NSString *Id = [object group_id];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"Title":[object group_name], @"IsGroup":@1}];
                }
            }];
        };
        _pView.addProjectBlock = ^(ProjectsView *tmpView){
            [wself creatGroupAction];
        };
        _pView.longPressBlock = ^(ProjectsView *tmpView, id object) {
            TTGroupViewController *groupVC = [[TTGroupViewController alloc] init];
            groupVC.groupId = [object group_id];
            groupVC.gid = [object group_id];
            [wself.navigationController pushViewController:groupVC animated:YES];
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

@end
