//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "YZInputView.h"
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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, HeadViewDelegate, HomeCellDelegate, VoteHomeCellDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataManager *manager;
@property (assign, nonatomic) BOOL isShowHeaderView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet YZInputView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;
@property (assign, nonatomic) NSInteger index;

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
    keyBoardBGView = _bgView;
    // 监听文本框文字高度改变
    _textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        _bgViewHeightConstraint.constant = textHeight + 10;
    };
    // 设置文本框最大行数
    _textView.maxNumberOfLines = 4;
    _textView.placeholder = @"评论";
    
    [self configureNavigationItem];
    [self handleRefreshAction];
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoteHomeCell" bundle:nil] forCellReuseIdentifier:@"VoteHomeCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    [_bgView endEditing:YES];
}

#pragma mark -- 键盘上的视图显示和隐藏
- (void)keyBoardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _bgViewBottomConstraint.constant = keyBoardFrame.origin.y != kScreenHeight ? keyBoardFrame.size.height : -100;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
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
                          @"imageCount":@(2),
                          @"time":@"2016年8月10日 14:25",
                          @"headImage":@"touxiang",
                          @"name":@"齐云猛",
                          @"type":@"易会",
                          @"image1":@"image",
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        static NSString *homeCell = @"homeCell";
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
        if (cell == nil) {
            if (model.imageCount == 1) {
                cell = LoadFromNib(@"HomeCell");
            }else if (model.imageCount == 2) {
                cell = LoadFromNib(@"HomeCell1");
            }else if (model.imageCount == 3) {
                cell = LoadFromNib(@"HomeCell2");
            }else {
                cell = LoadFromNib(@"HomeCell3");
            }
        }
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.moreBtn.indexPath = indexPath;
        [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.clickCommentBtn = ^(UIButton *btn) {
            self.index = indexPath.row;
            [self.textView becomeFirstResponder];
        };
        [cell.tableView reloadData];
        return cell;
    }else {
        VoteHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteHomeCell"];
        cell.model = model;
        cell.moreBtn.indexPath = indexPath;
        [cell.moreBtn addTarget:self action:@selector(handleVoteHomeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.clickBtn = ^(UIButton *btn) {
            self.index = indexPath.row;
            [self.textView becomeFirstResponder];
        };
        kWeakObject(cell);
        [cell setVoteClick:^(UIButton *sender) {
            switch (sender.tag) {
                case 100:{
                    sender.selected = !sender.selected;
                    if (sender.selected) {
                        [weakObject.aBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
                    }else {
                        [weakObject.aBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
                    }
                }
                    break;
                case 101:{
                    sender.selected = !sender.selected;
                    if (sender.selected) {
                        [weakObject.bBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
                    }else {
                        [weakObject.bBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
                    }
                }
                    break;
                case 102:{
                    sender.selected = !sender.selected;
                    if (sender.selected) {
                        [weakObject.cBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
                    }else {
                        [weakObject.cBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
                    }
                }
                    break;
            }
        }];
        [cell.tableView reloadData];
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
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)handleVoteHomeAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    model.isClick = !model.isClick;
    if (model.isClick) {
        
    }else {
        model.height = 0.0;
    }
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        if (model.imageCount == 4) {
            if (model.height == 0) {
                if (model.isClick) {
                    return 353 + [HomeCell tableViewHeight];
                }else {
                    return 353;
                }
            }else{
                return 353 + model.height;
            }
        }else {
            if (model.height == 0) {
                if (model.isClick) {
                    return 253 + [HomeCell tableViewHeight];
                }else {
                    return 253;
                }
            }else{
                return 253 + model.height;
            }
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSDictionary *dic = nil;
        HomeCellModel *model = self.manager.dataSource[self.index];
        if (model.projectType == ProjectTypeAll) {
            dic = @{@"time":[Common getCurrentSystemTime],
                    @"firstName":@"赵瑞",
                    @"secondName":@"@曹兴星",
                    @"des":_textView.text,
                    @"typeCell":@(TypeCellTitleNoButton)};
        }else {
            dic = @{@"time":[Common getCurrentSystemTime],
                    @"firstName":@"曹兴星",
                    @"secondName":@"C",
                    @"typeCell":@(TypeCellTitleNoButton)
                    };
        }
        HomeDetailCellModel *detailModel = [HomeDetailCellModel modelWithDic:dic];
        [model.comment insertObject:detailModel atIndex:0];
        model.isClick = YES;
        [self.tableView reloadData];
        [_bgView endEditing:YES];
        return NO;
    }
    return YES;
}




@end
