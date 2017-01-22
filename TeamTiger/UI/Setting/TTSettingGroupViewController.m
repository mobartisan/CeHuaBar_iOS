//
//  TTSettingGroupViewController.m
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTSettingGroupViewController.h"
#import "CJGroupCell.h"
#import "DeleteFooterView.h"

@interface TTSettingGroupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,copy) NSString *groupName;

@end

@implementation TTSettingGroupViewController

#pragma mark - Getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 70.0)];
        UIButton *createBtn = [UIButton hyb_buttonWithTitle:@"创建新组" superView:_footerView constraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(50);
        } touchUp:^(UIButton *sender) {
            [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.leftBtn setImage:nil forState:UIControlStateNormal];
            self.rightBtn.hidden = NO;
            
            self.tableView.tableFooterView.hidden = YES;
            TT_Group *group = [[TT_Group alloc] init];
            group.type = 1;
            [self.dataSource addObject:group];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
        setViewCorner(createBtn, 5);
        createBtn.layer.borderWidth = 1.5;
        createBtn.layer.borderColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1].CGColor;
        [createBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:21.0 / 255.0 green:27.0 / 255.0 blue:38.0 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
        [createBtn setTitleColor:[UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _footerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    [Common removeExtraCellLines:self.tableView];
    [self getGroupList];
    self.tableView.tableFooterView = self.footerView;
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"组";
    //左侧
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 20);
    [leftBtn setTitleColor:kRGB(114, 136, 160) forState:UIControlStateNormal];
    [leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
    leftBtn.tintColor = [UIColor whiteColor];
    [leftBtn addTarget:self action:@selector(handleReturnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.hidden = YES;
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    [rightBtn setTitleColor:kRGB(80, 154, 239) forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleReturnBackAction:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"取消"]) {
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setImage:kImage(@"icon_back") forState:UIControlStateNormal];
        self.rightBtn.hidden = YES;
        
        
        NSInteger index = self.dataSource.count - 1;
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.tableView.tableFooterView.hidden = NO;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleRightBtnAction {
    if ([Common isEmptyString:self.groupName]) {
        [super showText:@"请输入分组名称" afterSeconds:1.0];
        return;
    }
    GroupCreatApi *groupCreatApi = [[GroupCreatApi alloc] init];
    groupCreatApi.requestArgument = @{@"group_name":self.groupName,
                                      @"pids":@[]};
    [groupCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"creatGroupAction:%@", request.responseJSONObject);
        [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self.leftBtn setTitle:@"" forState:UIControlStateNormal];
            [self.leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
            self.rightBtn.hidden = YES;
            
            self.tableView.tableFooterView.hidden = NO;
            [self.dataSource removeAllObjects];
            [self getGroupList];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
    
}

#pragma mark - 获取所有的分组
- (void)getGroupList {
    AllGroupsListApi *api = [[AllGroupsListApi alloc] init];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSArray *groupArr = request.responseJSONObject[OBJ][@"groups"];
            if ([Common isEmptyArr:groupArr]) {
                [super showText:@"您暂无项目分组" afterSeconds:1.0];
            } else {
                for (NSDictionary *groupsDic in request.responseJSONObject[OBJ][@"groups"]) {
                    TT_Group *group = [[TT_Group alloc] init];
                    group.group_id = groupsDic[@"_id"];
                    group.group_name = groupsDic[@"group_name"];
                    group.type = 0;
                    [self.dataSource addObject:group];
                }
                
            }
            [self.tableView reloadData];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TT_Group *group = self.dataSource[indexPath.row];
    static NSString *cellID = @"CJGroupCell";
    CJGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (group.type == 0) {
            cell = LoadFromNib(@"CJGroupCell");
        } else {
            cell = LoadFromNib(@"CJGroupCell1");
        }
    }
    cell.group = group;
    cell.lastRow = ((self.dataSource.count - 1) == indexPath.row);
    cell.actionBlcok = ^(CJGroupCellClickType type, NSString *text) {
        switch (type) {
            case CJGroupCellClickTypeText:{
                self.groupName = text;
                break;
            }
            case CJGroupCellClickTypeBtn:{
                group.is_allow_delete = YES;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self moveProjectTo_group:group];
                break;
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

#pragma mark - 移动项目
- (void)moveProjectTo_group:(TT_Group *)group {
    MoveProjectApi *moveProjectApi = [[MoveProjectApi alloc] init];
    moveProjectApi.requestArgument = @{@"to_gid":group.group_id,
                                       @"pid":self.project_id};//pid 项目id
    [moveProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"moveProject:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (self.selectGroup) {
                self.selectGroup(group.group_name);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"moveProject:%@", error);
        if (error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }
    }];
}



@end
