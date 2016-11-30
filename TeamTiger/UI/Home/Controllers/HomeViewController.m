//
//  HomeViewController.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeCommentModelFrame.h"
#import "HomeCommentModel.h"
#import "HomeCell.h"
#import "HomeVoteCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "ButtonIndexPath.h"
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
#import "MockDatas.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,  HomeCellDelegate, HomeVoteCellDeleagte>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, weak) UIImageView *imageView;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;


@end

@implementation HomeViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
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
        
        setBtn.sd_layout.topSpaceToView(_headerView, imageViewH - 20).rightSpaceToView(_headerView, 17).widthIs(122).heightIs(40);
        
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
    bView = self.view;
    self.title = @"Moments";
    [self.dataSource addObjectsFromArray:[MockDatas getMomentsWithId:nil IsProject:NO IsAll:YES]];
    [self configureNavigationItem];
#warning TO DO ....
    [self handleRefreshAction];
    self.tableView.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.tableHeaderView = self.headerView;
    [Common removeExtraCellLines:self.tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"refresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConvertId:) name:@"ConvertId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)handleRefreshAction {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    self.tableView.mj_footer = footer;
    
    
}

- (void)handleTapTableViewAction:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    //项目列表
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

- (void)handleBgImageTap {
    [self.view endEditing:YES];
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
                CFRelease(imgR);
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
    [self.view endEditing:YES];
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

- (void)handleRefresh:(NSNotification *)notification {
    NSIndexPath *indexPath = notification.object;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)handleKeyBoard:(NSNotification *)notification {
    if (!self.currentIndexPath) {
        return;
    }
    HomeModel *homdModel = self.dataSource[self.currentIndexPath.row];
    CGFloat height = homdModel.indexModel.homeCommentModel.open ? homdModel.totalHeight : homdModel.partHeight;
    CGRect keyBoradFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HomeCell *cell = (HomeCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    CGRect cellF = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delt = CGRectGetMaxY(cellF) - (kScreenHeight - keyBoradFrame.size.height) - height - 10;
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delt;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setContentOffset:offset animated:YES];
    }];
    
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
        cell = (HomeCell *)[HomeCell cellWithTableView:tableView];
        ((HomeCell *)cell).commentBtn.indexPath = indexPath;
        ((HomeCell *)cell).delegate = self;
        ((HomeCell *)cell).homeModel = model;
    } else {
        cell = (HomeVoteCell *)[HomeVoteCell cellWithTableView:tableView];
        ((HomeVoteCell *)cell).homeModel = model;
        ((HomeVoteCell *)cell).delegate = self;
        ((HomeVoteCell *)cell).projectBtn.indexPath = indexPath;
    }
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)handleConvertId:(NSNotification *)notification {
    //loading
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在拼命加载...";
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hideAnimated:YES afterDelay:1.0];
    //data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (notification.userInfo && [notification.userInfo[@"ISGROUP"] intValue] == 1) {
            [self getDataWithProjectId:notification.object IsGroup:notification.userInfo[@"ISGROUP"]];
        } else {
            [self getDataWithProjectId:notification.object];
        }
    });
}


#pragma mark HomeCellDelegate
- (void)clickCommentBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.currentIndexPath = indexPath;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//点击项目名称
- (void)clickProjectBtn:(NSString *)projectId {
    [self showLoadingView:projectId];
}

#pragma mark HomeVoteCellDeleagte
//点击项目名称
- (void)clickVoteProjectBtn:(NSString *)projectId {
    [self showLoadingView:projectId];
}

- (void)clickVoteBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showLoadingView:(NSString *)projectId {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在拼命加载...";
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hideAnimated:YES afterDelay:1.0];
    //data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDataWithProjectId:projectId];
    });
}

- (void)getDataWithProjectId:(NSString *)Id {
    [self.dataSource removeAllObjects];
    if (![Common isEmptyString:Id]) {
        [self.dataSource addObjectsFromArray:[MockDatas getMomentsWithId:Id IsProject:YES IsAll:NO]];
    }else {
        [self.dataSource setArray:[MockDatas getMomentsWithId:Id IsProject:YES IsAll:YES]];
    }
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((HomeModel *)obj).open = NO;
    }];
    
    [self.tableView reloadData];
}

- (void)getDataWithProjectId:(NSString *)Id IsGroup:(BOOL)isGroup {
    if (isGroup) {
        //group
        [self.dataSource removeAllObjects];
        if (![Common isEmptyString:Id]) {
            [self.dataSource addObjectsFromArray:[MockDatas getMomentsWithId:Id IsProject:NO IsAll:NO]];
        }else {
            [self.dataSource setArray:[MockDatas getMomentsWithId:Id IsProject:YES IsAll:YES]];
        }
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((HomeModel *)obj).open = NO;
        }];
        [self.tableView reloadData];
    } else {
        //project
        [self getDataWithProjectId:Id];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
