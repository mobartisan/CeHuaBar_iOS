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
#import "NSString+Utils.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, HomeCellDelegate, HomeVoteCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;//数据源
@property (strong, nonatomic) UIView *sectionHeader;//分区页眉
@property (strong, nonatomic) UIView *tableHeader;//tableView 页眉
@property (strong, nonatomic) NSIndexPath *currentIndexPath;//键盘上移时对应cell的indexPath

@property (strong, nonatomic) UIButton *titleView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLB;
@property (strong, nonatomic) UIButton *setBtn;//设置按钮
@property (strong, nonatomic) UIButton *leftBtn;//左侧按钮

@property (assign, nonatomic) BOOL showTableHeader;

@property (strong, nonatomic) NSDictionary *tempDic;
@property (strong, nonatomic) TT_Project *tempProject;//项目
@property (strong, nonatomic) TT_Group *tempGroup;//分组

@end

@implementation HomeViewController


#pragma mark - 分区页眉
- (UIView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [UIView new];
        _sectionHeader.clipsToBounds = YES;
        _sectionHeader.backgroundColor = kRGBColor(28, 37, 51);
//        _sectionHeader.backgroundColor = [UIColor redColor];
        CGFloat imageViewH = kScreenWidth * 767 / 1242;
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
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
        setBtn.hidden = YES;
        [setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [setBtn setTitleColor:[Common colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
        setBtn.titleEdgeInsets = UIEdgeInsetsMake(-3, 30, 0, 0);
        [setBtn setBackgroundImage:[UIImage imageNamed:@"btn_project_setting"] forState:UIControlStateNormal];
        setBtn.layer.cornerRadius = 15;
        setBtn.layer.masksToBounds = YES;
        [setBtn addTarget:self action:@selector(handleSetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.setBtn = setBtn;
        [_sectionHeader addSubview:setBtn];
        
        imageView.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, 0).rightSpaceToView(_sectionHeader, 0).heightIs(imageViewH);
        
        textLB.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, 0).rightSpaceToView(_sectionHeader, 0).heightIs(imageViewH);
        
        setBtn.sd_layout.topSpaceToView(_sectionHeader, imageViewH - 20).rightSpaceToView(_sectionHeader, 17).widthIs(122).heightIs(40);

        [_sectionHeader setupAutoHeightWithBottomView:setBtn bottomMargin:0];
        [_sectionHeader layoutSubviews];
    }
    return _sectionHeader;
}

#pragma mark - tableView页眉
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

- (UIButton *)titleView {
    if (_titleView == nil) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.enabled = NO;
        _titleView.frame = CGRectMake(0, 0, 300, 40);
    }
    return _titleView;
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
        settingVC.project = self.tempProject;
        settingVC.requestData = ^(){
            self.setBtn.hidden = YES;
            [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
            self.tempDic = nil;
            [self getAllMoments:self.tempDic];
        };
        [self.navigationController pushViewController:settingVC animated:YES];
    }else {
        TTGroupSettingViewController *settingVC = [[TTGroupSettingViewController alloc] init];
        settingVC.requestData = ^(NSString *groupName, ExitType type){
            if (type == ExitTypeDelete) {
                self.setBtn.hidden = YES;
                [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
                [self.titleView setImage:nil forState:UIControlStateNormal];
                self.tempDic = nil;
                [self getAllMoments:self.tempDic];
            } else {
                [self.titleView setTitle:groupName forState:UIControlStateNormal];
            }
            
        };
        settingVC.group = self.tempGroup;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

//MARK:- 删除用户所有数据
- (void)deleteAllData {
    DeleteAllDataApi *deleteApi = [[DeleteAllDataApi alloc] init];
    [deleteApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"DeleteAllDataApi:%@", request.responseJSONObject);
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"DeleteAllDataApi:%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bView = self.view;
    [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
    self.navigationItem.titleView = self.titleView;
    self.tempDic = nil;
    [self getAllMoments:self.tempDic];
    [self configureNavigationItem];
    //下拉刷新
    [self handleDownRefreshAction];
    
    self.tableView.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = NO;
    [Common removeExtraCellLines:self.tableView];
    if (self.showTableHeader) {
        self.tableView.tableHeaderView = self.tableHeader;
        
    }
    self.setBtn.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConvertId:) name:@"ConvertId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    //测试
//    [self deleteAllData];
}

#pragma mark 获取Moments
- (void)getAllMoments:(NSDictionary *)requestDic {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AllMomentsApi *projectsApi = [[AllMomentsApi alloc] init];
    projectsApi.requestArgument = requestDic;
    [projectsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getAllMoments:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.dataSource = [NSMutableArray array];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic = request.responseJSONObject[OBJ];
            if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
                if (![Common isEmptyArr:objDic[@"list"]]) {
                    for (NSDictionary *dic in objDic[@"list"]) {
                        HomeModel *homeModel = [HomeModel modelWithDic:dic];
                        [self.dataSource addObject:homeModel];
                    }
                }
            }
            //封面
            if (kIsDictionary(objDic[@"banner"]) && [[objDic[@"banner"] allKeys] count] != 0) {
                self.textLB.hidden = YES;
                NSString *bannerURL = objDic[@"banner"][@"url"];
//                UIImage *tempImage = kImage(@"defaultBG");
//                if ([[self.tempDic allKeys] count] != 0) {
//                    tempImage = kImage(@"img_cover");
//                }
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:bannerURL] placeholderImage:self.imageView.image];
            } else {
                self.textLB.hidden = NO;
                if ([[self.tempDic allKeys] count] != 0 && ![[self.tempDic allKeys] containsObject:@"gid"]) {
                    self.textLB.hidden = YES;
                    self.imageView.image = kImage(@"img_cover");
                }
            }
            
            
            //更多数据
            if (![Common isEmptyString:objDic[@"next"]]) {
                [self handleUpRefreshAction:objDic[@"next"]];
            }
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
            self.setBtn.hidden = YES;
            [self.titleView setImage:nil forState:UIControlStateNormal];
            [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
        }
        
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 下拉刷新
- (void)handleDownRefreshAction {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAllMoments:self.tempDic];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 上拉刷新
- (void)handleUpRefreshAction:(NSString *)tempURL {
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![Common isEmptyString:tempURL] && !(self.dataSource.count % 10) && ![Common isEmptyArr:self.dataSource]) {
            [self getMoreDataWithUrl:tempURL];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark - 加载更多数据
- (void)getMoreDataWithUrl:(NSString *)urlString {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSDictionary *headerFieldValueDictionary = @{@"authorization":[NSString stringWithFormat:@"Bearer %@",gSession]};
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    manager.requestSerializer = requestSerializer;
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *objDic = responseObject[OBJ];
        if ([responseObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:objDic[@"list"]]) {
                for (NSDictionary *dic in objDic[@"list"]) {
                    HomeModel *homeModel = [HomeModel modelWithDic:dic];
                    [self.dataSource addObject:homeModel];
                }
            }
            
            //更多数据
            if (![Common isEmptyString:objDic[@"next"]]) {
                [self handleUpRefreshAction:objDic[@"next"]];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@":%@", error);
        [self.tableView.mj_footer endRefreshing];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
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
    self.leftBtn = leftBtn;
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

- (void)handleRightBtnAction {
    [self.view endEditing:YES];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            TTAddDiscussViewController *addDiscussVC = [[TTAddDiscussViewController alloc] init];
            addDiscussVC.addDiscussBlock = ^() {
                [self getAllMoments:self.tempDic];
            };
            [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addDiscussVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
        } else if (index == 1) {
            TTAddVoteViewController *addVoteVC = [[TTAddVoteViewController alloc] init];
            addVoteVC.addVoteBlock = ^() {
                [self getAllMoments:self.tempDic];
            };
            [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addVoteVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
        }
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    NSArray *items =
    @[MMItemMake(@"创建Moment", MMItemTypeNormal, block),
      MMItemMake(@"发起投票", MMItemTypeNormal, block)];
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView showWithBlock:completeBlock];
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
                UIImage *uploadImg = [UIImage imageWithCGImage:imgR];
                CFRelease(imgR);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeAnnularDeterminate;
                hud.label.text = @"正在上传...";
                [QiniuUpoadManager uploadImage:uploadImg progress:^(NSString *key, float percent) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"---->%lf",percent);
                        hud.progress = percent;
                    });
                } success:^(NSString *url) {
                    NSDictionary *dic = @{@"type":@0,
                                          @"from":@3,
                                          @"url":url};
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *bannerStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [self bannerUpdate:@{@"medias":bannerStr} UploadImage:uploadImg];
                    });
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@", error);
                        [hud hideAnimated:YES];
                        [super showText:@"您的网络好像有问题~" afterSeconds:1.5];
                    });
                }];
            };
            
            TTBaseNavigationController *selectNav = [[TTBaseNavigationController alloc] initWithRootViewController:selectBgImageVC];
            [self presentViewController:selectNav animated:YES completion:nil];
        }
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    NSArray *items = @[MMItemMake(@"更换相册封面", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView showWithBlock:completeBlock];
}

#pragma mark - 更改封面
- (void)bannerUpdate:(NSDictionary *)requestDic UploadImage:(UIImage *)uploadImg{
    UploadImageApi *uploadImageApi = [[UploadImageApi alloc] init];
    uploadImageApi.requestArgument = requestDic;
    [uploadImageApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"UploadImageApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            //修改图片
            self.imageView.image = uploadImg;
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"UploadImageApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
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
        ((HomeCell *)cell).delegate = self;
        ((HomeCell *)cell).homeModel = model;
        ((HomeCell *)cell).clickMoreBtnBlock = ^(NSIndexPath *tmpIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView scrollToRowAtIndexPath:tmpIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        };
    } else {
        cell = (HomeVoteCell *)[HomeVoteCell cellWithTableView:tableView];
        ((HomeVoteCell *)cell).homeModel = model;
        ((HomeVoteCell *)cell).delegate = self;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenWidth * 767 / 1242 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [UIScreen mainScreen].scale;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

#pragma mark - 分组或者项目Moments
- (void)handleConvertId:(NSNotification *)notification {
    NSDictionary *parameterDic = nil;
    if (notification.object && [notification.userInfo[@"IsGroup"] intValue] == 1) {//分组
        parameterDic = @{@"gid":[notification.object group_id]};
        
        self.setBtn.hidden = NO;
        self.imageView.userInteractionEnabled = YES;
        
        [self.titleView setImage:kImage(@"icon_moments") forState:UIControlStateNormal];
        self.titleView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
        [self.setBtn setTitle:@"分组设置" forState:UIControlStateNormal];
        
        self.tempGroup = notification.object;
    }else if (notification.object && [notification.userInfo[@"IsGroup"] intValue] == 0) {//项目
        parameterDic = @{@"pid":[notification.object project_id]};
        self.setBtn.hidden = NO;
        self.imageView.userInteractionEnabled = NO;
        
        [self.titleView setImage:nil forState:UIControlStateNormal];
        [self.leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
        [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
        
        self.tempProject = notification.object;
    } else {//主页
        self.setBtn.hidden = YES;
        self.imageView.userInteractionEnabled = YES;
        
        [self.leftBtn setImage:kImage(@"icon_sidebar") forState:UIControlStateNormal];
        
    }
    [self getAllMoments:parameterDic];
    self.tempDic = parameterDic;
    [self.titleView setTitle:notification.userInfo[@"Title"] forState:UIControlStateNormal];
}


#pragma mark - HomeCellDelegate
- (void)clickCommentBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.currentIndexPath = indexPath;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//点击项目名称
- (void)clickProjectBtn:(TT_Project *)project {
    self.setBtn.hidden = NO;
    self.imageView.userInteractionEnabled = NO;
    self.tempProject = project;
    [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
    [self.titleView setImage:nil forState:UIControlStateNormal];
    [self.titleView setTitle:project.name forState:UIControlStateNormal];
    [self getAllMoments:@{@"pid":project.project_id}];//pid 项目id
}

#pragma mark - HomeVoteCellDeleagte
//点击项目名称
- (void)clickVoteProjectBtn:(TT_Project *)project {
    self.setBtn.hidden = NO;
    self.imageView.userInteractionEnabled = NO;
    self.tempProject = project;
    [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
    [self.titleView setImage:nil forState:UIControlStateNormal];
    [self.titleView setTitle:project.name forState:UIControlStateNormal];
    [self getAllMoments:@{@"pid":project.project_id}];//pid 项目id
}


- (void)clickVoteBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickVoteSuccess:(NSIndexPath *)indexPath homeModel:(HomeModel *)model {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.dataSource insertObject:model atIndex:indexPath.row];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
