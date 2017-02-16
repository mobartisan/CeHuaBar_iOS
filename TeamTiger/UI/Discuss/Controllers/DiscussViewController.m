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
#import "TTBaseViewController+NotificationHandle.h"

@interface DiscussViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL isNeedRefresh;

@end

@implementation DiscussViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSDictionary *)idDictionary {
    if (!_idDictionary) {
        _idDictionary = [NSDictionary dictionary];
    }
    return _idDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    self.tableView.rowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [Common removeExtraCellLines:self.tableView];
    
    //处理通知
    [self handleNotificationWithBlock:^(id notification) {
        if (notification) {
            if ([notification isKindOfClass:[TT_Message class]]) {
                TT_Message *message = (TT_Message *)notification;
                if (message.message_type == 3) {
                    //项目变更
                    //如果有消息，且消息类型符合页面展示条件，则显示消息UI
                    [self getMessageListWithParameter:self.idDictionary];
                }
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMessageListWithParameter:self.idDictionary];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeCustomObserver:self Name:NOTICE_KEY_MESSAGE_COMING Object:nil];
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"讨论";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        if (self.isNeedRefresh) {
            self.isNeedRefresh = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_NEED_REFRESH_MOMENTS_2 object:nil];
        }
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

//FIXME: - 未完
- (void)getMessageListWithParameter:(id)parameter {
    MessageListApi *api = [[MessageListApi alloc] init];
    if (parameter) {
        api.requestArgument = parameter;
    }
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"MessageListApi:%@", request.responseJSONObject);
        [self.dataSource removeAllObjects];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            for (NSDictionary *dic in request.responseJSONObject[OBJ][@"list"]) {
                DiscussListModel *model = [[DiscussListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [super showText:NETWORKERROR afterSeconds:1.0];
        NSLog(@"MessageListApi:%@", error);
    }];
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
    discussListDetailVC.mid = model.mid;
    self.isNeedRefresh = YES;
    [self.navigationController pushViewController:discussListDetailVC animated:YES];
}

@end
