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
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    [self getProjectsList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.requestData) {
        self.requestData(self.groupId);
    }
}


- (void)getProjectsList {
    ProjectsApi *projectsApi = [[ProjectsApi alloc] init];
    projectsApi.requestArgument = @{@"gid":self.groupId};
    [projectsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getProjectsList:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic = request.responseJSONObject[OBJ];
            TT_Group *group = [[TT_Group alloc] init];
            group.group_id = objDic[@"_id"];
            group.group_name = objDic[@"group_name"];
            self.groupInfo = group;
            
            self.projects = [NSMutableArray array];
            NSArray *pidsArr = request.responseJSONObject[OBJ][@"pids"];
            for (NSDictionary *projectDic in pidsArr) {
                TT_Project *tt_project = [[TT_Project alloc] init];
                tt_project.name = projectDic[@"name"];
                tt_project.project_id = projectDic[@"_id"];
                [self.projects addObject:tt_project];
            }
            [self.table reloadData];
        } else {
            [super showText:@"分组下项目查询失败" afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellID = @"CellIdentifyGroup";
        GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = LoadFromNib(@"GroupCell");
        }
        cell.nameTxtField.text = self.groupInfo.group_name;
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
                    [self deleteProjectGid:self.groupId pid:projectInfo];
                }
            }];
        };
        //置顶cell回调block
        ((ProjectsCell *)cell).addMember = ^{
            [self projectTopWithProject:projectInfo];
        };
        ((ProjectsCell *)cell).noDisturbBlokc = ^{
            [self projectDisturbWithProject:projectInfo];
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
    headView.addProjectBtn.hidden = YES;
    if (section == 0) {
        headView.groupNameLab.text = @"分组名称";
    } else {
        headView.groupNameLab.text = @"项目列表";
    }
    headView.addProjectBtn.hidden = YES;
    return headView;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


#pragma mark - 项目置顶
- (void)projectTopWithProject:(TT_Project *)project {
    NSNumber *position = project.isTop ? @2 : @1;
    ProjectTopApi *projectTopApi = [[ProjectTopApi alloc] init];
    projectTopApi.requestArgument = @{@"pid":project.project_id,
                                      @"position":position};
    [projectTopApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectDeleteApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
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
            [self.table reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectDisturbApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark  从某个分组删除项目
- (void)deleteProjectGid:(NSString *)gid pid:(TT_Project *)project {
    DeleteProjectApi *deleteProjectApi = [[DeleteProjectApi alloc] init];
    deleteProjectApi.requestArgument = @{@"pid":project.project_id,//项目ID
                                         @"gid":gid};//分组ID
    [deleteProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [super showText:@"删除项目成功" afterSeconds:1.0];
            [self.projects removeObject:project];
            [self.table reloadData];
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
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
            self.groupInfo = nil;
            [self.projects removeAllObjects];
            [self.table reloadData];
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"GroupDeleteApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
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
        
        WeakSelf;
        self.footView = LoadFromNib(@"DeleteFooterView");
        self.footView.deleteGroupBlock = ^(DeleteFooterView *view){
            if (self.groupInfo == nil || [self.groupInfo isEqual:[NSNull null]]) {
                [super showText:@"该分组已不存在" afterSeconds:1.0];
                return;
            }
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该分组吗？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [wself groupDeleteWithGroup:wself.groupInfo];
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

- (void)addProject:(id)sender {
    // add project
    TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
    TTBaseNavigationController *baseNav = [[TTBaseNavigationController alloc] initWithRootViewController:addProfileVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
}

- (void)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
