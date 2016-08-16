//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "HeadView.h"
#import "HomeCell.h"
#import "VoteHomeCell.h"
#import "HomeDetailCell5.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "TTSettingViewController.h"
#import "TTAddDiscussViewController.h"
#import "DiscussViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, HeadViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger projectType;
@property (strong, nonatomic) DataManager *manager;

@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) BOOL isShowHeaderView;

@end

@implementation HomeViewController

- (DataManager *)manager {
    if (_manager == nil) {
        _manager = [DataManager mainSingleton];
    }
    return _manager;
}

- (void)reloadWithData:(id)data {
    self.title = data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    [self handleRefreshAction];
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoteHomeCell" bundle:nil] forCellReuseIdentifier:@"VoteHomeCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"isClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClickCard:) name:@"ClickCard" object:nil];
}

- (void)handleRefreshAction {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];;
    self.tableView.mj_header = header;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self addDataToDataArr];
//        [self.tableView reloadData];
//        [self.tableView.mj_footer endRefreshing];
//    }];
//    self.tableView.mj_footer = footer;
    
}

- (void)addDataToDataArr {
    if (self.manager.dataSource.count > 4) {
        return;
    }
    NSDictionary *dic = @{@"headImage":@"touxiang",
                          @"name":@"卞克",
                          @"type":@"BBS",
                          @"image1":@"image",
                          @"image2":@"image",
                          @"image3":@"image",
                          @"aDes":@"tape something",
                          @"bDes":@"tape something",
                          @"cDes":@"tape something",
                          @"aTicket":@"0.7",
                          @"bTicket":@"0.4",
                          @"cTicket":@"0.1",
                          @"comment":@[
                                  @{@"time":@"19:50",
                                    @"firstName":@"卞克",
                                    @"secondName":@"A",
                                    @"des":@"卞克",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTimeAndTitle)
                                    },
                                  @{@"time":@"13:55",
                                    @"firstName":@"卞克",
                                    @"secondName":@"A",
                                    @"typeCell":@(TypeCellName)
                                    },
                                  @{@"time":@"9:55",
                                    @"firstName":@"唐小旭",
                                    @"secondName":@"B",
                                    @"typeCell":@(TypeCellTimeAndTitle)
                                    }].mutableCopy
                          };
    [self.manager.dataArr addObject:dic];
    HomeCellModel *model = [HomeCellModel modelWithDic:dic];
    [self.manager.dataSource addObject:model];
    
}

- (void)handleRefresh:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    if ([dic[@"type"] isEqualToString:@"0"]) {
        self.height = ((NSNumber *)(dic[@"height"])).floatValue;
    }else {
        self.manager.height = ((NSNumber *)(dic[@"height"])).floatValue;
    }
    [self.tableView reloadData];
}

- (void)handleClickCard:(NSNotification *)notification {
    self.projectType = ((NSNumber *)(notification.object)).integerValue;
    [self.tableView reloadData];
}

- (void)configureNavigationItem {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:kImage(@"icon_install") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(handleLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:kImage(@"icon_add") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleLeftBtnAction {
    TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
    [Common customPushAnimationFromNavigation:self.navigationController ToViewController:settingVC Type:kCATransitionPush SubType:kCATransitionFromLeft];
}

- (void)handleRightBtnAction {
    TTAddDiscussViewController *addDiscussVC = [[TTAddDiscussViewController alloc] init];
    [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addDiscussVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClickCard" object:nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.projectType) {
        case 0:
            return self.manager.dataSource.count;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    switch (self.projectType) {
        case 0:{
            if (indexPath.row == 0) {
                HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
                [cell configureCellWithModel:model indexPath:indexPath];
                if (model.isClick) {
                    [cell.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
                }else {
                    [cell.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
                }
                cell.moreBtn.indexPath = indexPath;
                [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else {
                VoteHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteHomeCell"];
                [cell configureCellWithModel:model indexPath:indexPath];
                if (model.isClick) {
                    [cell.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
                }else {
                    [cell.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
                }
                cell.moreBtn.indexPath = indexPath;
                [cell.moreBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.clickBtn = ^ (UIButton *btn){
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        [btn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
                    }else {
                        [btn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
                    }
                };
                return cell;
            }
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:{
            HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
            cell.moreBtn.indexPath = indexPath;
            [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell configureCellWithModel:model indexPath:indexPath];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (void)handleClickAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    HomeDetailCellModel *detailModel = model.comment[self.manager.index];
    model.isClick = !model.isClick;
    HomeCell *cell = (HomeCell *)button.superview.superview.superview;
    if (model.isClick) {
        [cell.tableView reloadData];
        self.height = cell.tableView.contentSize.height;
    }else {
        if (self.manager.index != 0) {
            detailModel.isClick = NO;
            detailModel.typeCell = TypeCellTitle;
        }
        [cell.tableView reloadData];
    }
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)handleAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    HomeDetailCellModel *detailModel = model.comment[self.manager.index1];
    model.isClick = !model.isClick;
    VoteHomeCell *cell = (VoteHomeCell *)button.superview.superview.superview;
    if (model.isClick) {
        [cell.tableView reloadData];
        self.manager.height = cell.tableView.contentSize.height;
    }else {
        detailModel.isClick = NO;
        [cell.tableView reloadData];
    }
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:button.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    switch (self.projectType) {
        case 0:{
            if (indexPath.row == 0) {
                if (model.isClick) {
                    return 253 + self.height + 5;
                }else {
                    return 253;
                }
            }else {
                if (model.isClick) {
                    return 431 + self.manager.height + 5;
                }else {
                    return 431;
                }
            }
        }
            break;
        case 1:{
            
        }
        case 2:{
            
        }
        case 3:{
            
        }
        case 4:{
            if (model.isClick) {
                return 253 + self.height + 5;
            }else {
                return 253;
            }
        }
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isShowHeaderView) {
        HeadView *headerView = [HeadView headerViewWithTableView:tableView];
        headerView.delegate = self;
        return headerView;
    }else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isShowHeaderView) {
        return 60;
    }else {
        return 0;
    }
}

#pragma mark HeadViewDelegate
- (void)headViewDidClickWithHeadView:(HeadView *)headView {
    DiscussViewController *discussVC = [[DiscussViewController alloc] init];
    [self.navigationController pushViewController:discussVC animated:YES];
}

@end
