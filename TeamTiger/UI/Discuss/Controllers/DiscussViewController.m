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
#import "DiscussListCell1.h"

@interface DiscussViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation DiscussViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        NSDictionary *dic1 = @{@"iconName":@"touxiang", @"name":@"俞弦", @"des":@"Type Something...", @"time":@"1分钟之前", @"imageName":@"placeImage", @"des2":@""};
        DiscussListModel *model1 = [[DiscussListModel alloc] init];
        [model1 setValuesForKeysWithDictionary:dic1];
        [_dataSource addObject:model1];
        
        NSDictionary *dic2 = @{@"iconName":@"touxiang", @"name":@"焦兰兰", @"des":@"Type Something...", @"time":@"3分钟之前", @"imageName":@"placeImage", @"des2":@""};
        DiscussListModel *model2 = [[DiscussListModel alloc] init];
        [model2 setValuesForKeysWithDictionary:dic2];
        [_dataSource addObject:model2];
        
        NSDictionary *dic3 = @{@"iconName":@"touxiang", @"name":@"齐云猛", @"des":@"Type Something...", @"time":@"7月18日 15:11", @"imageName":@"placeImage", @"des2":@"事件2Type Something..."};
        DiscussListModel *model3 = [[DiscussListModel alloc] init];
        [model3 setValuesForKeysWithDictionary:dic3];
        [_dataSource addObject:model3];
        
        NSDictionary *dic4 = @{@"iconName":@"touxiang", @"name":@"卞克", @"des":@"Type Something...", @"time":@"7月18日 15:10", @"imageName":@"placeImage", @"des2":@"事件2Type Something..."};
        DiscussListModel *model4 = [[DiscussListModel alloc] init];
        [model4 setValuesForKeysWithDictionary:dic4];
        [_dataSource addObject:model4];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讨论";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kRGB(90, 108, 128) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 80.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscussListCell" bundle:nil] forCellReuseIdentifier:@"discussListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscussListCell1" bundle:nil] forCellReuseIdentifier:@"discussListCell1"];
    [Common removeExtraCellLines:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussListModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == 1) {
        DiscussListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discussListCell" forIndexPath:indexPath];
        [cell configureCellWithModel:model];
        return cell;
    }else {
        DiscussListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discussListCell1" forIndexPath:indexPath];
        [cell configureCellWithModel:model];
        return cell;
    }
    
}

@end
