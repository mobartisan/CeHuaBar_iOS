//
//  SelectCircleViewController.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SelectCircleViewController.h"
#import "TTCommonCell.h"
#import "TTCommonItem.h"
#import "TTCommonGroup.h"
#import "TTCommonArrowItem.h"
// Controllers

// Model

// Views
//#define <#macro#> <#value#>

@interface SelectCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *circles;
@end
#pragma mark - View Controller LifeCyle
@implementation SelectCircleViewController

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
    self.circles = [CirclesManager sharedInstance].circles;
    
    for (NSString *title in self.circles) {
        TTCommonItem *vote = [TTCommonArrowItem itemWithTitle:title subtitle:nil destVcClass:nil];
        
        TTCommonGroup *group = [[TTCommonGroup alloc] init];
        group.items = [NSMutableArray arrayWithArray:@[vote]];
        [self.data addObject:group];
    }
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
    TTCommonGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    TTCommonCell *cell = [TTCommonCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    TTCommonGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.lastRowInSection =  (group.items.count - 1 == indexPath.row);
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    TTCommonGroup *group = self.data[indexPath.section];
    TTCommonItem *item = group.items[indexPath.row];
    
//    if (self.selectCircleVCBlock) {
//        self.selectCircleVCBlock(self.circles[indexPath.section], self);
//    }
//    [[CacheManager sharedInstance] setObject:item.title ForKey:TTSelectCircle_Cache_Key];
    [CirclesManager sharedInstance].selectIndex = indexPath.section;
    [self.navigationController popViewControllerAnimated:YES];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[TTCommonArrowItem class]]) { // 箭头
        TTCommonArrowItem *arrowItem = (TTCommonArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TTCommonGroup *group = self.data[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    TTCommonGroup *group = self.data[section];
    return group.footer;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
