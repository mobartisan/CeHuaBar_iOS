//
//  SelectCircleViewController.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SelectCircleViewControllerForSetting.h"
#import "TTCommonCell.h"
#import "TTCommonItem.h"
#import "TTCommonGroup.h"
#import "TTCommonArrowItem.h"
#import "MockDatas.h"

@interface SelectCircleViewControllerForSetting ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@end
#pragma mark - View Controller LifeCyle
@implementation SelectCircleViewControllerForSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorForBackgroud;
    // Do any additional setup after loading the view.
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.tableView];
    [self layoutSubviews];
    
    [self setupGroups];
}

-(void)layoutSubviews{
    WeakSelf;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Override

#pragma mark - Initial Methods
- (void)setupGroups {
    self.data = [MockDatas projects].mutableCopy;
}
#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    TTCommonCell *cell = [TTCommonCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    id object = self.data[indexPath.section];
    TTCommonItem *item = [TTCommonItem itemWithTitle:object[@"Name"]];
    cell.item = item;
    cell.lastRowInSection = 0;
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectCircleVCBlock) {
        self.selectCircleVCBlock(self.data[indexPath.section], self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 77;
    }
    return _tableView;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

@end
