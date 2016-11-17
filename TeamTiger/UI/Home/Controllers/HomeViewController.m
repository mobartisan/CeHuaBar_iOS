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
#import "SelectBgImageVC.h"
#import "UIImage+YYAdd.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, weak) UIImageView *imageView;
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
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月26日 19:50"},
                                               @{@"name":@"卞克",
                                                 @"sName":@"@唐小绪",
                                                 @"content":@"哈哈哈",
                                                 @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg"],
                                                 @"time":@"7月26日 13:55"},
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
                                @{@"cellType":@"0",
                                  @"iconImV":@"9",
                                  @"name":@"唐小旭",
                                  @"project":@"BBS",
                                  @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_1.jpg", @"image_2.jpg", @"image_3.jpg"],
                                  @"time":@"7月20日 9:45",
                                  @"comment":@[@{@"name":@"唐小旭",
                                                 @"sName":@"@卞克",
                                                 @"content":@"测试数据测试数据测试数据测试数据",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月23日 20:30"},
                                               @{@"name":@"曹兴星",
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
                                                 @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg"],
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
                                               ].mutableCopy},
                                @{@"cellType":@"0",
                                  @"iconImV":@"6",
                                  @"name":@"赵瑞",
                                  @"project":@"易会",
                                  @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据",
                                  @"photeNameArry":@[@"image_4.jpg", @"image_9.jpg"],
                                  @"time":@"7月20日 9:45",
                                  @"comment":@[@{@"name":@"唐小旭",
                                                 @"sName":@"@卞克",
                                                 @"content":@"测试数据测试数据",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月19日 20:30"},
                                               @{@"name":@"卞克",
                                                 @"sName":@"@唐小绪",
                                                 @"content":@"哈哈哈",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月18日 15:05"},
                                               @{@"name":@"俞弦",
                                                 @"sName":@"",
                                                 @"content":@"有点意思",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月18日 12:01"},
                                               @{@"name":@"唐小旭",
                                                 @"sName":@"",
                                                 @"content":@"滴滴滴滴的",
                                                 @"photeNameArry":@[],
                                                 @"time":@"7月18日 11:30"}
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
        _headerView.clipsToBounds = YES;
        _headerView.backgroundColor = kRGBColor(28, 37, 51);
        
        CGFloat imageViewH = kScreenWidth * 767 / 1242;
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"image_3.jpg"];
        [_headerView addSubview:imageView];
        _imageView = imageView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(handleTapImageAction)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *textLB = [UILabel new];
        textLB.userInteractionEnabled = YES;
        textLB.tag = 1001;
        textLB.textAlignment = NSTextAlignmentCenter;
        textLB.text = @"轻触设置moment封面";
        textLB.textColor = [Common colorFromHexRGB:@"3f608b"];
        textLB.backgroundColor = [Common colorFromHexRGB:@"212e41"];
        [_headerView addSubview:textLB];
        UITapGestureRecognizer *tapLB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLBAction)];
        [textLB addGestureRecognizer:tapLB];
        
        
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
        
        textLB.sd_layout.leftSpaceToView(_headerView, 0).topSpaceToView(_headerView, 0).rightSpaceToView(_headerView, 0).heightIs(imageViewH);
        
        setBtn.sd_layout.topSpaceToView(_headerView, imageViewH - 17).rightSpaceToView(_headerView, 17).widthIs(120).heightIs(34);
        
        [_headerView setupAutoHeightWithBottomView:setBtn bottomMargin:5];
        [_headerView layoutSubviews];
    }
    return _headerView;
}

//点击图片
- (void)handleTapImageAction {
    [self handleBgImageTap];
}

- (void)handleTapLBAction {
    [self handleBgImageTap];
}

//设置按钮
- (void)handleSetBtnAction {
    TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"refresh" object:nil];
}

- (void)handleTapTableViewAction:(UIGestureRecognizer *)tap {
    [self.tableView endEditing:YES];
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
    [rightBtn setImage:kImage(@"icon_add_moment") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleProjectsBtnAction {
    //项目列表
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

- (void)handleBgImageTap {
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            SelectBgImageVC *selectBgImageVC = [[SelectBgImageVC alloc] init];
            WeakSelf;
            selectBgImageVC.selectCircleVCBlock = ^(UIImage *selectImage, SelectBgImageVC *selectBgImageVC) {
                [_headerView viewWithTag:1001].hidden = YES;
                // 获取当前使用的图片像素和点的比例
                CGFloat scale = [UIScreen mainScreen].scale;
                // 裁减图片
                CGImageRef imgR = CGImageCreateWithImageInRect(selectImage.CGImage, CGRectMake(0, 0, wself.imageView.size.width * scale, wself.imageView.size.height * scale));
                wself.imageView.image = [UIImage imageWithCGImage:imgR];
            };
            
            TTBaseNavigationController *selectNav = [[TTBaseNavigationController alloc] initWithRootViewController:selectBgImageVC];
            [self presentViewController:selectNav animated:YES completion:nil];
        }
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    NSArray *items =
    @[MMItemMake(@"更换相册封面", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil
                                                          items:items];
    //    sheetView.attachedView = self.view;
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView showWithBlock:completeBlock];
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
    // 定义唯一标识
    UITableViewCell *cell = nil;
    if (model.cellType == 0) {
        cell = (HomeCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCell class])];
        ((HomeCell *)cell).commentBtn.indexPath = indexPath;
        ((HomeCell *)cell).tableView.indexPath = indexPath;
        [((HomeCell *)cell) setCommentBtnClick:^(NSIndexPath *indexPath1) {
            [self.tableView reloadData];
        }];
        ((HomeCell *)cell).homeModel = model;
    } else {
        cell = (HomeVoteCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeVoteCell class])];
        ((HomeVoteCell *)cell).homeModel = model;
    }
    //     此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    //    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeModel *model = self.dataSource[indexPath.row];
    Class currentClass;
    if (model.cellType == 0) {
        currentClass = [HomeCell class];
    } else {
        currentClass = [HomeVoteCell class];
    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"homeModel" cellClass:currentClass contentViewWidth:kScreenWidth];
}


@end
