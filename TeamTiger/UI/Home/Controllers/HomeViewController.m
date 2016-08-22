//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "UIView+KeyBoardShowAndHidden.h"
#import "IQKeyboardManager.h"
#import "ButtonIndexPath.h"
#import "HeadView.h"
#import "HomeCell.h"
#import "VoteHomeCell.h"
#import "HomeDetailCell5.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "TTSettingViewController.h"
#import "TTAddDiscussViewController.h"
#import "DiscussViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, HeadViewDelegate, HomeCellDelegate, VoteHomeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataManager *manager;
@property (assign, nonatomic) BOOL isShowHeaderView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;

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
    
    [_bgView showAccessoryViewAnimation];
    [_bgView hiddenAccessoryViewAnimation];
}

- (void)handleRefreshAction {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self addDataToDataArr];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer = footer;
    
}

- (void)addDataToDataArr {
    if (self.manager.dataSource.count > 3) {
        return;
    }
    NSDictionary *dic = @{@"projectType":@(ProjectTypeAll),
                          @"headImage":@"touxiang",
                          @"name":@"唐小旭",
                          @"type":@"工作牛",
                          @"image1":@"placeImage",
                          @"image2":@"image",
                          @"image3":@"image",
                          @"comment":@[
                                  @{@"time":@"20:51",
                                    @"firstName":@"曹兴星",
                                    @"secondName":@"@卞克",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton)
                                    },
                                  @{@"time":@"13:55",
                                    @"firstName":@"卞克",
                                    @"secondName":@"@唐小旭",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton)
                                    },
                                  @{@"time":@"9:00",
                                    @"firstName":@"齐云猛",
                                    @"secondName":@"",
                                    @"des":@"TypeSomething...",
                                    @"secondImage":@"image",
                                    @"firstImage":@"image",
                                    @"typeCell":@(TypeCellTitle)
                                    },
                                  @{@"time":@"昨天",
                                    @"firstName":@"2016年7月18日",
                                    @"secondName":@"@唐小旭",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTime)
                                    },
                                  @{@"time":@"13:55",
                                    @"firstName":@"俞弦",
                                    @"secondName":@"",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton),
                                    },
                                  ].mutableCopy
                          };
    [self.manager.dataArr addObject:dic];
    HomeCellModel *model = [HomeCellModel modelWithDic:dic];
    [self.manager.dataSource addObject:model];
    
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
    [IQKeyboardManager sharedManager].enable = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        if (model.isClick) {
            [cell.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
        }else {
            [cell.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
        }
        cell.moreBtn.indexPath = indexPath;
        [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.clickCommentBtn = ^(UIButton *btn) {
            self.bgViewBottomConstraint.constant = 0;
            [self.view setNeedsLayout];
            [self.textView becomeFirstResponder];
        };
        return cell;
    }else {
        VoteHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteHomeCell"];
        cell.model = model;
        if (model.isClick) {
            [cell.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
        }else {
            [cell.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
        }
        cell.moreBtn.indexPath = indexPath;
        [cell.moreBtn addTarget:self action:@selector(handleVoteHomeAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
}

- (void)handleClickAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    model.isClick = !model.isClick;
    if (model.isClick) {
        
    }else {
        model.height = 0.0;
    }
    [self.tableView reloadData];
}

- (void)handleVoteHomeAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    model.isClick = !model.isClick;
    if (model.isClick) {
        
    }else {
        model.height = 0.0;
    }
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        if (model.height == 0) {
            if (model.isClick) {
                return 253 + [HomeCell tableViewHeight];
            }else {
                return 253;
            }
        }else{
            return 253 + model.height;
        }
    }else {
        if (model.height == 0) {
            if (model.isClick) {
                return 431 + [HomeCell tableViewHeight];
            }else {
                return 431;
            }
        }else{
            return 431 + model.height;
        }
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.bgView endEditing:YES];
}

#pragma mark HomeCellDelegate
- (void)reloadHomeTableView:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    
}

#pragma mark VoteHomeCellDelegate
- (void)reloadTableViewWithHeight:(CGFloat)height withIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    
}
#pragma mark HeadViewDelegate
- (void)headViewDidClickWithHeadView:(HeadView *)headView {
    DiscussViewController *discussVC = [[DiscussViewController alloc] init];
    [self.navigationController pushViewController:discussVC animated:YES];
}


#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView  shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([@"\n" isEqualToString: text]){
        [self.bgView endEditing:YES];
        self.bgViewBottomConstraint.constant = -40;
        [self.view setNeedsLayout];
        return NO;
    }
    return YES;
    
}



@end
