//
//  DiscussViewController.m
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DiscussViewController.h"
#import "DiscussListModel.h"
#import "DiscussListCell.h"
#import "DiscussListDetailViewController.h"

@interface DiscussViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation DiscussViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        NSArray *tempArr = @[
                             @{@"_id":@"5887667996ebce26481ad762",@"iconName":@"img_user", @"name":@"俞弦", @"des":@"Type Something...", @"time":@"2017-02-10 10:29:27", @"imageName":@"img_cover", @"des2":@"Type Something..."},
                             @{@"_id":@"5887667996ebce26481ad762",@"iconName":@"img_user", @"name":@"焦兰兰", @"des":@"Type Something...", @"time":@"2017-02-10 10:10:27", @"imageName":@"img_cover", @"des2":@"Type Something..."},
                             @{@"_id":@"5887667996ebce26481ad762",@"iconName":@"img_user", @"name":@"焦兰兰", @"des":@"Type Something...", @"time":@"2017-02-10 10:20:27", @"imageName":@"img_cover", @"des2":@"Type Something..."},
                             @{@"_id":@"5887667996ebce26481ad762",@"iconName":@"img_user", @"name":@"卞克", @"des":@"Type Something...", @"time":@"2017-02-10 10:30:00", @"imageName":@"", @"des2":@"事件2Type Something..."}
                             ];
        for (NSDictionary *dic in tempArr) {
            DiscussListModel *model = [[DiscussListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    self.tableView.rowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [Common removeExtraCellLines:self.tableView];
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"讨论";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    if ([Common isEmptyArr:self.dataSource]) {
        rightBtn.userInteractionEnabled = NO;
        [rightBtn setTitleColor:kRGB(91, 109, 130) forState:UIControlStateNormal];
    } else {
        rightBtn.userInteractionEnabled = YES;
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)handleRightBtnAction:(UIButton *)sender {
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:kRGB(91, 109, 130) forState:UIControlStateNormal];
#warning to do...
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussListModel *model = self.dataSource[indexPath.row];
    DiscussListCell *cell = [DiscussListCell cellWithTableView:tableView withModel:model];
    [cell configureCellWithModel:model withHideLineView:(indexPath.row == self.dataSource.count - 1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscussListModel *model = self.dataSource[indexPath.row];
    DiscussListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [Common colorFromHexRGB:@"1c293b"];
    [UIView animateWithDuration:0.3 animations:^{
        cell.backgroundColor = kRGB(28, 37, 51);
    }];
    DiscussListDetailViewController *discussListDetailVC = [[DiscussListDetailViewController alloc] init];
    discussListDetailVC._id = model._id;
    [self.navigationController pushViewController:discussListDetailVC animated:YES];
}

@end
