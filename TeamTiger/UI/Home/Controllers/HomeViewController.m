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
#import "TTGroupSettingViewController.h"
#import "UIImage+Extension.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,  HomeCellDelegate, HomeVoteCellDeleagte>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *sectionHeader;
@property (strong, nonatomic) UIView *tableHeader;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) UIButton *titleView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLB;
@property (strong, nonatomic) UIButton *setBtn;
@property (assign, nonatomic) BOOL showTableHeader;

@property (copy, nonatomic) NSString *current_group_id;
@property (copy, nonatomic) NSString *current_project_id;
@property (copy, nonatomic) NSString *bannerImageURL;


@end

@implementation HomeViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//talbeView 分区页眉
- (UIView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [UIView new];
        _sectionHeader.clipsToBounds = YES;
        _sectionHeader.backgroundColor = kRGBColor(28, 37, 51);
        
        CGFloat imageViewH = kScreenWidth * 767 / 1242;
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"image_3.jpg"];
        [_sectionHeader addSubview:imageView];
        self.imageView = imageView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(handleTapImageAction)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *textLB = [UILabel new];
        textLB.userInteractionEnabled = YES;
        textLB.textAlignment = NSTextAlignmentCenter;
        textLB.text = @"轻触设置moment封面";
        textLB.textColor = [Common colorFromHexRGB:@"3f608b"];
        textLB.backgroundColor = [Common colorFromHexRGB:@"212e41"];
        self.textLB = textLB;
        [_sectionHeader addSubview:textLB];
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
        [setBtn addTarget:self action:@selector(handleSetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _setBtn = setBtn;
        [_sectionHeader addSubview:setBtn];
        
        imageView.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, 0).rightSpaceToView(_sectionHeader, 0).heightIs(imageViewH);
        
        textLB.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, 0).rightSpaceToView(_sectionHeader, 0).heightIs(imageViewH);
        
        setBtn.sd_layout.topSpaceToView(_sectionHeader, imageViewH - 20).rightSpaceToView(_sectionHeader, 17).widthIs(122).heightIs(40);
        
        [_sectionHeader setupAutoHeightWithBottomView:setBtn bottomMargin:5];
        [_sectionHeader layoutSubviews];
    }
    return _sectionHeader;
}

- (UIView *)tableHeader {
    if (_tableHeader == nil) {
        _tableHeader = [UIView new];
        _tableHeader.backgroundColor = [UIColor clearColor];
        _tableHeader.frame = CGRectMake(0, 0, 0, 50);
        
        UIImageView *bellImage = [UIImageView new];
        bellImage.image = kImage(@"icon_bell");
        [_tableHeader addSubview:bellImage];
        
        UILabel *countLB = [UILabel new];
        countLB.text = @"4";
        countLB.textColor = [UIColor whiteColor];
        countLB.backgroundColor = kRGB(45, 201, 202);
        countLB.textAlignment = NSTextAlignmentCenter;
        countLB.layer.cornerRadius = 10;
        countLB.layer.masksToBounds = YES;
        [_tableHeader addSubview:countLB];
        
        
        UIButton *bellBtn = [UIButton new];
        [bellBtn addTarget:self action:@selector(handleBellBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeader addSubview:bellBtn];
        
        [bellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(_tableHeader);
            make.centerX.equalTo(_tableHeader);
        }];
        
        [countLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(20);
            make.centerX.equalTo(_tableHeader).offset(15);
            make.centerY.equalTo(_tableHeader).offset(-20 / 2);
        }];
        
        [bellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableHeader);
        }];
    }
    return _tableHeader;
}

- (void)handleBellBtnAction {
    DiscussViewController *discussVC = [[DiscussViewController alloc] init];
    [self.navigationController pushViewController:discussVC animated:YES];
}

//点击图片
- (void)handleTapImageAction {
    [self handleBgImageTap];
}

- (void)handleTapLBAction {
    [self handleBgImageTap];
}

//设置按钮
- (void)handleSetBtnAction:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"项目设置"]) {
        TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
        settingVC.project_id = self.current_project_id;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else {
        TTGroupSettingViewController *settingVC = [[TTGroupSettingViewController alloc] init];
        settingVC.groupId = self.current_group_id;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bView = self.view;
    [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
    self.navigationItem.titleView = self.titleView;

    [self configureNavigationItem];
    self.tableView.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 250;
#warning TO DO ....
    [self handleRefreshAction];
    [Common removeExtraCellLines:self.tableView];
    if (self.showTableHeader) {
        self.tableView.tableHeaderView = self.tableHeader;
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"refresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConvertId:) name:@"ConvertId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.dataSource removeAllObjects];
    
}

- (void)getAllProjects {
    [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
}

- (UIButton *)titleView {
    if (_titleView == nil) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.enabled = NO;
        _titleView.frame = CGRectMake(0, 0, 300, 40);
    }
    return _titleView;
}

#warning to do 获取所有Moments
- (void)getAllMoments:(NSDictionary *)requestDic {
    if (![Common isEmptyArr:self.dataSource]) {
        [self.dataSource removeAllObjects];
    }
    AllMomentsApi *projectsApi = [[AllMomentsApi alloc] init];
    projectsApi.requestArgument = requestDic;
    [projectsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getAllMoments:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            
            if (![Common isEmptyArr:request.responseJSONObject[OBJ][@"list"]]) {
                for (NSDictionary *dic in request.responseJSONObject[OBJ][@"list"]) {
                    HomeModel *homeModel = [HomeModel modelWithDic:dic];
                    [self.dataSource addObject:homeModel];
                }
            }
        }
        
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.5];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self getAllMoments:@{@"page":@"1",
                          @"rows":@"10"}];
    [self getAllProjects];
    
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
                self.textLB.hidden = YES;
                UIImage *normalImage = [selectImage normalizedImage];
                // 获取当前使用的图片像素和点的比例
                CGFloat scale = [UIScreen mainScreen].scale;
                // 裁减图片
                CGImageRef imgR = CGImageCreateWithImageInRect(normalImage.CGImage, CGRectMake(0, 0, wself.imageView.size.width * scale, wself.imageView.size.height * scale));
                wself.imageView.image = [UIImage imageWithCGImage:imgR];
                CFRelease(imgR);
#warning to do 封面
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [QiniuUpoadManager uploadImage:wself.imageView.image progress:^(NSString *key, float percent) {
                        
                    } success:^(NSString *url) {
                        NSDictionary *dic = @{@"uid":[TT_User sharedInstance].user_id,
                                              @"url":url,
                                              @"type":@0,
                                              @"from":@3};//0-discuss  1-moments  2-vote  3-banner
                        NSArray *arr = @[dic];
                        NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *urlsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        [self bannerUpdate:@{@"medias":urlsStr}];
                    } failure:^(NSError *error) {
                        NSLog(@"%@", error);
                        [super showText:@"您的网络好像有问题~" afterSeconds:1.5];
                    }];
                });
                
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
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView showWithBlock:completeBlock];
}

//更改封面
- (void)bannerUpdate:(NSDictionary *)requestDic {
    UploadImageApi *uploadImageApi = [[UploadImageApi alloc] init];
    uploadImageApi.requestArgument = requestDic;
    [uploadImageApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"bannerUpdate:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"bannerUpdate:%@", error);
        if (error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1];
        }
    }];
    
}

- (void)handleRightBtnAction {
    [self.view endEditing:YES];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMPopupItemHandler block = ^(NSInteger index){
        if (![Common isEmptyArr:[CirclesManager sharedInstance].circles]) {
            [[CirclesManager sharedInstance].circles removeAllObjects];
            [self getAllProjects];
        }
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
    if (model.cellType == 1) {
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
    if (model.cellType == 1) {
        currentClass = [HomeCell class];
    } else {
        currentClass = [HomeVoteCell class];
    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"homeModel" cellClass:currentClass contentViewWidth:kScreenWidth];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [UIScreen mainScreen].scale;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)handleConvertId:(NSNotification *)notification {
    //loading
    [super showText:@"正在拼命加载..." afterSeconds:1.0];
    //data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (notification.userInfo && [notification.userInfo[@"IsGroup"] intValue] == 1) {
            [self getAllMoments:@{@"page":@"1",
                                  @"rows":@"10",
                                  @"gid":notification.object}];//gid 分组id
            
            [self.titleView setImage:kImage(@"icon_moments") forState:UIControlStateNormal];
            self.titleView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }else {
            [self getAllMoments:@{@"page":@"1",
                                  @"rows":@"10",
                                  @"pid":notification.object}];//pid 项目id
            [self.titleView setImage:kImage(@"") forState:UIControlStateNormal];
        }
        [self.titleView setTitle:notification.userInfo[@"Title"] forState:UIControlStateNormal];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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

- (void)clickVoteSuccess:(NSIndexPath *)indexPath homeModel:(HomeModel *)model {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.dataSource insertObject:model atIndex:indexPath.row];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
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
        [self.dataSource addObjectsFromArray:[MockDatas getMoments2WithId:Id IsProject:YES IsAll:NO]];
    }else {
        [self.dataSource setArray:[MockDatas getMoments2WithId:Id IsProject:YES IsAll:YES]];
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
            [self.dataSource addObjectsFromArray:[MockDatas getMoments2WithId:Id IsProject:NO IsAll:NO]];
        }else {
            [self.dataSource setArray:[MockDatas getMoments2WithId:Id IsProject:YES IsAll:YES]];
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
