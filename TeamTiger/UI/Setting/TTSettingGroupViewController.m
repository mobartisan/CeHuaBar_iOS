//
//  TTSettingGroupViewController.m
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTSettingGroupViewController.h"
#import "CJGroupCell.h"

@interface TTSettingGroupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation TTSettingGroupViewController

#pragma mark - Getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    
    
    [Common removeExtraCellLines:self.tableView];
    [self getGroupList];
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"组";
    //左侧
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 20);
    [leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
    leftBtn.tintColor = [UIColor whiteColor];
    [leftBtn addTarget:self action:@selector(handleReturnBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 20);
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleReturnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleRightBtnAction {
    
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
    static NSString *cellID = @"CJGroupCell";
    CJGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CJGroupCell" owner:nil options:nil] firstObject];
    }
    cell.group = self.dataSource[indexPath.row];
    cell.lastRow = ((self.dataSource.count - 1) == indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TT_Group *objGroup = (TT_Group *)obj;
        if (idx == indexPath.row) {
            objGroup.is_allow_delete = !objGroup.is_allow_delete;
        } else {
            objGroup.is_allow_delete = NO;
        }
    }];
    [tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CJGroupCell *tableFooterView = [[[NSBundle mainBundle] loadNibNamed:@"CJGroupCell" owner:nil options:nil] lastObject];
    tableFooterView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    return tableFooterView;
}


@end
