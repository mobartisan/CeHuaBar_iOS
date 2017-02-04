//
//  TTGroupViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTGroupViewController.h"
#import "ProjectsCell.h"
#import "TTAddProjectViewController.h"
#import "TTSettingViewController.h"
#import "GroupHeadView.h"
#import "UIViewController+MMDrawerController.h"
#import "SelectGroupView.h"

@interface TTGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableDictionary *groupInfo;

@property(nonatomic,strong)SelectGroupView *sgView;
@property (strong, nonatomic) NSMutableArray *groups;

@end

@implementation TTGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目";
    self.projects = [NSMutableArray array];
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
    [self.table reloadData];
}

- (void)getProjectsList {
    ProjectsApi *projectsApi = [[ProjectsApi alloc] init];
    projectsApi.requestArgument = @{@"gid":self.gid};
    [projectsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getProjectsList:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:self.projects]) {
                [self.projects removeAllObjects];
            }
            NSArray *pidsArr = [request.responseJSONObject[OBJ] firstObject][@"pids"];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getProjectsList];
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
    id projectInfo = self.projects[indexPath.row];
    [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.projects.count - 1];

    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ProjectsCell class]]) {
        ((ProjectsCell *)cell).backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        [UIView animateWithDuration:0.3 animations:^{
            ((ProjectsCell *)cell).backgroundColor = [UIColor clearColor];
          
        }];
    }
    //主页moments
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:self.projects[indexPath.row] userInfo:@{@"Title":[self.projects[indexPath.row] name], @"IsGroup":@0}];
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
        _table.separatorColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (void)addProjectIntoGroupAction:(id)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:self.groups];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            if (isConfirm) {
                [wself moveProjectFrom_gid:wself.groupId to_gid:[object group_id] pid:projectInfo];
            }
       
        };
    }
}


- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray arrayWithArray:self.allGroups];
    }
    return _groups;
}

//移动分组下某个项目到另一个分组
- (void)moveProjectFrom_gid:(NSString *)from_gid to_gid:(NSString *)to_gid pid:(TT_Project *)project {
    if ([from_gid isEqualToString:to_gid]) {
        [super showText:@"项目已存在该分组下" afterSeconds:1.5];
        return;
    }
    
    MoveProjectApi *moveProjectApi = [[MoveProjectApi alloc] init];
    moveProjectApi.requestArgument = @{@"from_gid":from_gid,
                                       @"to_gid":to_gid,
                                       @"pid":[project project_id]};//pid 项目id
    [moveProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"moveProject:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self.projects removeObject:project];
            [self.table reloadData];
            [super showText:@"项目已添加至该分组" afterSeconds:1.5];
        }else {
            [super showText:@"项目添加至该分组失败" afterSeconds:1.5];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"moveProject:%@", error);
        if (error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1.5];
        }
    }];
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
