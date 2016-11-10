//
//  HomeViewController.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "HomeVoteCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "ButtonIndexPath.h"
#include "TableViewIndexPath.h"
#import "TTSettingViewController.h"
#import "TTAddDiscussViewController.h"
#import "DiscussViewController.h"
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "TTAddVoteViewController.h"
#import "TTProjectsMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "IQKeyboardManager.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation HomeViewController

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        NSMutableArray *arr = @[
                                @{@"cellType":@"0",
                                  @"iconImV":@"1",
                                  @"name":@"唐小旭",
                                  @"project":@"工作牛",
                                  @"content":@"测试数据测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_4.jpg", @"image_4.jpg"],
                                  @"time":@"7月26日 9:45",
                                  @"comment":@[@{@"name":@"唐小旭",
                                                 @"sName":@"@卞克",
                                                 @"content":@"测试数据测试数据测试数据测试数据",
                                                 @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg"],
                                                 @"time":@"7月26日 19:50"},
                                               @{@"name":@"卞克",
                                                 @"sName":@"@唐小绪",
                                                 @"content":@"哈哈哈",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月26 13:55"},
                                               @{@"name":@"俞弦",
                                                 @"sName":@"",
                                                 @"content":@"有点意思",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月25日 14:17"},
                                               @{@"name":@"齐云猛",
                                                 @"sName":@"",
                                                 @"content":@"滴滴滴滴的",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月25日 9:30"}
                                               ].mutableCopy},
                                @{@"cellType":@"1",
                                  @"iconImV":@"1",
                                  @"name":@"唐小旭",
                                  @"project":@"工作牛",
                                  @"content":@"测试数据测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_7.jpg"],
                                  @"time":@"7月26日 9:45",
                                  @"aNum":@"7",
                                  @"bNum":@"2",
                                  @"cNum":@"1"},
                                @{@"iconImV":@"9",
                                  @"name":@"唐小旭",
                                  @"project":@"BBS",
                                  @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_1.jpg", @"image_2.jpg", @"image_3.jpg"],
                                  @"time":@"7月20日 9:45",
                                  @"comment":@[@{@"name":@"唐小旭",
                                                 @"sName":@"@卞克",
                                                 @"content":@"测试数据测试数据测试数据测试数据",
                                                 @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg"],
                                                 @"time":@"7月23日 20:30"},
                                               @{@"name":@"卞克",
                                                 @"sName":@"@唐小绪",
                                                 @"content":@"哈哈哈",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月22日 15:05"},
                                               @{@"name":@"俞弦",
                                                 @"sName":@"",
                                                 @"content":@"有点意思",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月22日 12:01"},
                                               @{@"name":@"齐云猛",
                                                 @"sName":@"",
                                                 @"content":@"滴滴滴滴的",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月22日 11:30"}
                                               ].mutableCopy},
                                @{@"cellType":@"0",
                                  @"iconImV":@"5",
                                  @"name":@"曹兴星",
                                  @"project":@"工作牛",
                                  @"content":@"测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_4.jpg"],
                                  @"time":@"7月20日 9:45",
                                  @"comment":@[@{@"name":@"唐小旭",
                                                 @"sName":@"@卞克",
                                                 @"content":@"测试数据测试数据测试数据测试数据",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月23日 20:30"},
                                               @{@"name":@"卞克",
                                                 @"sName":@"@唐小绪",
                                                 @"content":@"哈哈哈",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月23日 15:05"},
                                               @{@"name":@"俞弦",
                                                 @"sName":@"",
                                                 @"content":@"有点意思",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月23日 12:01"},
                                               @{@"name":@"齐云猛",
                                                 @"sName":@"",
                                                 @"content":@"滴滴滴滴的",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月22日 11:30"}
                                               ].mutableCopy}
                                ].mutableCopy;
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            HomeModel *homeModel = [HomeModel modelWithDic:dic];
            [dataArr addObject:homeModel];
        }
        _dataSource = dataArr;
    }
    return _dataSource;
}

//talbeView 页眉
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = kRGBColor(28, 37, 51);
        
        CGFloat imageViewH = kScreenWidth * 767 / 1242;
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"image_3.jpg"];
        [_headerView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(handleTapAction:)];
        [imageView addGestureRecognizer:tap];
        
        
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [setBtn setTitleColor:[Common colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
        setBtn.titleEdgeInsets = UIEdgeInsetsMake(-3, 30, 0, 0);
        [setBtn setBackgroundImage:[UIImage imageNamed:@"btn_project_setting"] forState:UIControlStateNormal];
        setBtn.layer.cornerRadius = 15;
        setBtn.layer.masksToBounds = YES;
        [setBtn addTarget:self action:@selector(handleSetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:setBtn];
        
        imageView.sd_layout.leftSpaceToView(_headerView, 0).topSpaceToView(_headerView, 0).rightSpaceToView(_headerView, 0).heightIs(imageViewH);
        
        setBtn.sd_layout.topSpaceToView(_headerView, imageViewH - 17).rightSpaceToView(_headerView, 17).widthIs(120).heightIs(34);
        
        [_headerView setupAutoHeightWithBottomView:setBtn bottomMargin:5];
        [_headerView layoutSubviews];
    }
    return _headerView;
}

//点击图片
- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"tap");
}

//设置按钮
- (void)handleSetBtnAction {
    NSLog(@"handleSetBtnAction");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationItem];
    self.view.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.tableHeaderView = self.headerView;
    [Common removeExtraCellLines:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"refresh" object:nil];
}


- (void)configureNavigationItem {
    
    //左侧
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 20);
    [leftBtn setImage:kImage(@"icon_sidebar") forState:UIControlStateNormal];
    leftBtn.tintColor = [UIColor whiteColor];
    [leftBtn addTarget:self action:@selector(handleProjectsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 20);
    [rightBtn setImage:kImage(@"icon_add") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleProjectsBtnAction {
    //项目列表
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

- (void)handleRightBtnAction {
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            TTAddDiscussViewController *addDiscussVC = [[TTAddDiscussViewController alloc] init];
            [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addDiscussVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
        } else if (index == 1) {
            TTAddVoteViewController *voteVC = [[TTAddVoteViewController alloc] init];
            [Common customPushAnimationFromNavigation:self.navigationController ToViewController:voteVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
        }
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    NSArray *items =
    @[MMItemMake(@"创建Moment", MMItemTypeNormal, block),
      MMItemMake(@"发起投票", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil
                                                          items:items];
    //    sheetView.attachedView = self.view;
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView showWithBlock:completeBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleRefresh:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.dataSource[indexPath.row];
    if (model.cellType == 0) {
        HomeCell *cell = [HomeCell cellWithTableView:tableView];
        cell.commentBtn.indexPath = indexPath;
        cell.tableView.indexPath = indexPath;
        [cell setCommentBtnClick:^(NSIndexPath *indexPath1) {
            [self.tableView reloadData];
        }];
        cell.homeModel = model;
        return cell;
    }else {
        HomeVoteCell *cell = [HomeVoteCell cellWithTableView:tableView];
        cell.homeModel = model;
        return cell;
    }
    /** 启用cell frame缓存（可以提高cell滚动的流畅度, 目前为cell专用方法，后期会扩展到其他view） */
    //        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%f", [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView]);
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView];
    
    //    HomeModel *model = self.dataSource[indexPath.row];
    //    Class currentClass = [HomeCell class];
    //    if (model.cellType == 1) {
    //        currentClass = [HomeVoteCell class];
    //    }
    //    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"homeModel" cellClass:currentClass contentViewWidth:kScreenWidth];
}


@end
