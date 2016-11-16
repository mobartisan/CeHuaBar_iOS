//
//  TTGroupViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTGroupViewController.h"
#import "ProjectsCell.h"
#import "MockDatas.h"
#import "TTAddProjectViewController.h"
#import "TTSettingViewController.h"
#import "GroupHeadView.h"
#import "UIViewController+MMDrawerController.h"

@interface TTGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableDictionary *groupInfo;

@end

@implementation TTGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 23, 23);
    [rightBtn setImage:kImage(@"icon_add") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(addProject:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //data
    [self loadProjects];
    [self.table reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentifyProject";
    ProjectsCell *cell = (ProjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = LoadFromNib(@"ProjectsCell");
    }
    cell.tag = indexPath.section * 1000  + indexPath.row;
    NSDictionary *projectInfo = self.projects[indexPath.row];
    [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.projects.count - 1];
    
    __weak typeof(cell) tempCell = cell;
    //设置删除cell回调block
    ((ProjectsCell *)cell).deleteMember = ^{
        [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目？" buttonTitles:@[@"确定",@"取消"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
        }];
    };
    //增加成员的cell回调block
    ((ProjectsCell *)cell).addMember = ^{
        [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要添加该项目至组？" buttonTitles:@[@"确定",@"取消"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
        }];
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
#warning to do
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GroupHeadView *headView = LoadFromNib(@"GroupHeadView");
    headView.isEnabledSwipe = NO;
    [headView loadHeadViewData:self.groupInfo];
    return headView;
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
    }
    return _table;
}

- (void)loadProjects {
    NSArray *groups = [MockDatas groups];
    NSArray *selGroups = [groups filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Gid"] isEqualToString:self.groupId];
    }]];
    
    self.groupInfo = [NSMutableDictionary dictionaryWithDictionary:selGroups.firstObject];
    NSArray *pids = [selGroups.firstObject[@"Pids"] componentsSeparatedByString:@","];

    NSArray *projects = [MockDatas projects];
    NSArray *selProjects = [projects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [pids containsObject:evaluatedObject[@"Id"]];
    }]];
    
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

@end
