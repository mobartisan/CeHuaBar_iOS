//
//  TTGroupViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTGroupSettingViewController.h"
#import "ProjectsCell.h"
#import "GroupCell.h"
#import "MockDatas.h"
#import "TTAddProjectViewController.h"
#import "TTSettingViewController.h"
#import "GroupHeadView.h"
#import "UIViewController+MMDrawerController.h"
#import "SelectGroupView.h"
#import "IQKeyboardManager.h"
#import "DeleteFooterView.h"

@interface TTGroupSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)TT_Group *groupInfo;

@property(nonatomic,strong)NSMutableArray *groups;

@property(nonatomic,strong)SelectGroupView *sgView;

@property(nonatomic,strong)DeleteFooterView *footView;

@end

@implementation TTGroupSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组设置";
    //left
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 23, 23);
    [leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
    leftBtn.tintColor = [UIColor whiteColor];
    [leftBtn addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 23, 23);
    [rightBtn setImage:kImage(@"icon_add_moment") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(addProject:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //data
    [self loadProjects];
    [self.table reloadData];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellID = @"CellIdentifyGroup";
        GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = LoadFromNib(@"GroupCell");
        }
        cell.nameTxtField.text = self.groupInfo.name;
        cell.endEditBlock = ^(GroupCell *cell, NSString *nameStr) {
            
        };
        return cell;
    } else {
        static NSString *cellID = @"CellIdentifyProject";
        ProjectsCell *cell = (ProjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = LoadFromNib(@"ProjectsCell");
        }
        cell.tag = indexPath.section * 1000  + indexPath.row;
        id projectInfo = self.projects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.projects.count - 1];
        ((ProjectsCell *)cell).msgNumLab.hidden = YES;
        ((ProjectsCell *)cell).msgNumBGImgV.hidden = YES;
        ((ProjectsCell *)cell).arrowImgV.hidden = YES;
        __weak typeof(cell) tempCell = cell;
        //设置删除cell回调block
        ((ProjectsCell *)cell).deleteMember = ^{
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    //从分组中删除
                    TT_Group *group = [SQLITEMANAGER selectDatasSql:[NSString stringWithFormat:@"select * from %@ where group_id = '%@'",TABLE_TT_Group, self.groupId] Class:TABLE_TT_Group].firstObject;
                    NSMutableArray *pids = [group.pids componentsSeparatedByString:@","].mutableCopy;
                    [pids removeObject:[projectInfo project_id]];
                    NSString *nwPids = [pids componentsJoinedByString:@","];
                    NSString *updateSql = [NSString stringWithFormat:@"update %@ set pids = '%@'",TABLE_TT_Group, nwPids];
                    [SQLITEMANAGER executeSql:updateSql];
                    [self.projects removeObjectAtIndex:indexPath.row];
                    [self.table reloadData];
                }
            }];
        };
        //增加成员的cell回调block
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
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GroupHeadView *headView = LoadFromNib(@"GroupHeadView");
    headView.isEnabledSwipe = NO;
    headView.messageNumLab.hidden = YES;
    if (section == 0) {
        headView.groupNameLab.text = @"分组名称";
    } else {
        headView.groupNameLab.text = @"项目列表";
    }
    return headView;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma -mark getter
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] init];
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 53;
        [Common removeExtraCellLines:_table];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        _table.backgroundView = v;
        _table.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        _table.separatorColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.footView = LoadFromNib(@"DeleteFooterView");
        self.footView.deleteGroupBlock = ^(DeleteFooterView *view){
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该分组吗？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    NSString *sql = [NSString stringWithFormat:@"update %@ set current_state = 1",TABLE_TT_Group];//设置为删除状态
                    [SQLITEMANAGER executeSql:sql];
                }
            }];
        };
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
        [tmpView addSubview:self.footView];
        [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tmpView);
        }];
        CGRect frame = tmpView.frame;
        frame.size.height = 60.0;
        tmpView.frame = frame;
        self.table.tableFooterView = tmpView;
    }
    return _table;
}

- (NSMutableArray *)groups {
    if (!_groups) {
        TT_User *user = [TT_User sharedInstance];
        [SQLITEMANAGER setDataBasePath:user.user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by create_date desc",TABLE_TT_Group];
        NSArray *groups = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Group];
        _groups = [NSMutableArray arrayWithArray:groups];
    }
    return _groups;
}

- (void)loadProjects {
    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where group_id = '%@'",TABLE_TT_Group, self.groupId];
    NSArray *groups = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Group];
    TT_Group *group = groups.firstObject;
    self.groupInfo = group;
    NSMutableString *mStr = [NSMutableString string];
    for (NSString *str in [group.pids componentsSeparatedByString:@","]) {
        [mStr appendFormat:@"'%@',",str];
    }
    [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 1, 1) withString:NullString];
    
    sql = [NSString stringWithFormat:@"select * from %@ where project_id in (%@) order by create_date",TABLE_TT_Project, mStr];
    
    NSArray *selProjects = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Project];
    if (!self.projects) {
        self.projects = [NSMutableArray arrayWithArray:selProjects];
    } else {
        [self.projects removeAllObjects];
        [self.projects addObjectsFromArray:selProjects];
    }
}


- (void)addProject:(id)sender {
    // add project
    TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
    TTBaseNavigationController *baseNav = [[TTBaseNavigationController alloc] initWithRootViewController:addProfileVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
}

- (void)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
                if ([pids containsObject:[projectInfo project_id]]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                        hud.label.text = @"项目已存在该分组";
                        hud.mode = MBProgressHUDModeText;
                        [hud hideAnimated:YES afterDelay:1.5];
                    });
                    return;
                } else {
                    //添加至分组
                    [pids addObject:[projectInfo project_id]];
                    NSString *nwPids = [pids componentsJoinedByString:@","];
                    NSString *updateSql = [NSString stringWithFormat:@"update %@ set pids = '%@'",TABLE_TT_Group, nwPids];
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    [SQLITEMANAGER executeSql:updateSql];
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
