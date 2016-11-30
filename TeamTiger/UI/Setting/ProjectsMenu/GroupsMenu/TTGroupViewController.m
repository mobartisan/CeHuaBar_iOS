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
#import "SelectGroupView.h"

@interface TTGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableDictionary *groupInfo;

@property(nonatomic,strong)NSMutableArray *groups;

@property(nonatomic,strong)SelectGroupView *sgView;

@end

@implementation TTGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目";
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f]];
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
        [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目？" buttonTitles:@[@"取消",@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
            if (buttonIndex == 1) {
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:self.projects[indexPath.row][@"Id"]];
        [self.navigationController popToRootViewControllerAnimated:NO];
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

- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray arrayWithArray:[MockDatas groups]];
    }
    return _groups;
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

- (void)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addProjectIntoGroupAction:(id)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:[MockDatas groups]];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@",object);
                //添加至分组
                NSArray *array = [NSArray arrayWithArray:wself.groups];
                [array enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[@"Gid"] isEqualToString:object[@"Gid"]]) {
                        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:obj];
                        NSMutableArray *pids = [NSMutableArray arrayWithArray:[obj[@"Pids"] componentsSeparatedByString:@","]];
                        [pids addObject:projectInfo[@"Id"]];
                        NSArray *srcArray = [NSSet setWithArray:pids].allObjects;
                        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch |NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
                        NSComparator sort = ^(NSString *obj1, NSString *obj2){
                            NSRange range = NSMakeRange(0, obj1.length);
                            return [obj1 compare:obj2 options:comparisonOptions range:range];
                        };
                        NSArray *resultArray = [srcArray sortedArrayUsingComparator:sort];
                        NSString *nwPids = [resultArray componentsJoinedByString:@","];
                        mDic[@"Pids"] = nwPids;
                        [wself.groups replaceObjectAtIndex:idx withObject:mDic];
                    }
                }];
                //刷新UI
                [wself.projects removeObject:projectInfo];
                [wself.table reloadData];
                //给出提示
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                    hud.label.text = @"项目已添加至该分组";
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:1.5];
                });
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
