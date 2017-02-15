//
//  DiscussListDetailViewController.m
//  TeamTiger
//
//  Created by Dale on 17/2/9.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "DiscussListDetailViewController.h"
#import "HomeCell.h"
#import "HomeVoteCell.h"
#import "HomeModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

@interface DiscussListDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation DiscussListDetailViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    [self getMomentDetail];
    self.tableView.rowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [Common removeExtraCellLines:self.tableView];
}

//FIXME: - 根据mid得到具体的moment
- (void)getMomentDetail {
    MomentDetailApi *api = [[MomentDetailApi alloc] init];
    api.requestArgument = @{@"mid":self.mid};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"MomentDetailApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic = request.responseJSONObject[OBJ];
            if (!kIsDictionary(objDic)) {
                HomeModel *homeModel = [HomeModel modelWithDic:objDic];
                [self.dataSource addObject:homeModel];
            }
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"MomentDetailApi:%@", error);
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
}

- (void)configureNavigationItem {
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark UITableViewDataSource && Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.dataSource[indexPath.row];
    // 定义唯一标识
    UITableViewCell *cell = nil;
    if (model.cellType == 1) {
        cell = (HomeCell *)[HomeCell cellWithTableView:tableView];
        ((HomeCell *)cell).commentBtn.indexPath = indexPath;
        ((HomeCell *)cell).homeModel = model;
    } else {
        cell = (HomeVoteCell *)[HomeVoteCell cellWithTableView:tableView];
        ((HomeVoteCell *)cell).homeModel = model;
        ((HomeVoteCell *)cell).projectBtn.indexPath = indexPath;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.dataSource[indexPath.row];
    Class currentClass;
    if (model.cellType == 1) {
        currentClass = [HomeCell class];
    } else {
        currentClass = [HomeVoteCell class];
    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"homeModel" cellClass:currentClass contentViewWidth:kScreenWidth];
}

@end
