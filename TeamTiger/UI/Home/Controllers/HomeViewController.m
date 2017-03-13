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
#import "NSNotificationCenter+Block.h"
#import "STPushView.h"
#import "DiscussListModel.h"
#import "TTBaseViewController+NotificationHandle.h"
#import "YYFPSLabel.h"
#import "CacheManager.h"
#import "Moments.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, HomeCellDelegate, HomeVoteCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;//数据源
@property (strong, nonatomic) UIView *sectionHeader;//分区页眉
@property (strong, nonatomic) UIView *tableHeader;//tableView 页眉
@property (strong, nonatomic) NSIndexPath *currentIndexPath;//键盘上移时对应cell的indexPath
@property (nonatomic,strong) UILabel *countLB;//未读消息个数label
@property (strong, nonatomic) UIButton *titleView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLB;
@property (strong, nonatomic) UIButton *setBtn;//设置按钮
@property (strong, nonatomic) UIButton *leftBtn;//左侧按钮

@property (strong, nonatomic) NSDictionary *tempDic;
@property (strong, nonatomic) TT_Project *tempProject;//项目
@property (strong, nonatomic) TT_Group *tempGroup;//分组
@property (nonatomic,strong) NSNotification *notification;
@property (strong, nonatomic) UIImagePickerController *imagePickerVc;
@property (assign, nonatomic) NSInteger memberType;
@end

@implementation HomeViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 分区页眉
- (UIView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [UIView new];
        _sectionHeader.clipsToBounds = YES;
        _sectionHeader.backgroundColor = kRGBColor(28, 37, 51);
        
        CGFloat imageViewH = kScreenWidth * kWidthHeightScale;
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = kImage(@"img_cover");
        [_sectionHeader addSubview:imageView];
        self.imageView = imageView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(handleTapImageAction)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *textLB = [UILabel new];
        textLB.userInteractionEnabled = YES;
        textLB.textAlignment = NSTextAlignmentCenter;
        textLB.text = @"轻触设置封面";
        textLB.textColor = [Common colorFromHexRGB:@"3f608b"];
        textLB.backgroundColor = [UIColor clearColor];
        textLB.font = [UIFont systemFontOfSize:15];
        self.textLB = textLB;
        [_sectionHeader addSubview:textLB];
        UITapGestureRecognizer *tapLB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLBAction)];
        [textLB addGestureRecognizer:tapLB];
        
        UIImageView *line = [UIImageView new];
        line.backgroundColor = [Common colorFromHexRGB:@"212e41"];
        [_sectionHeader addSubview:line];
        
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
        
        textLB.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, imageViewH - 80).rightSpaceToView(_sectionHeader, 0).heightIs(20);
        
        setBtn.sd_layout.topSpaceToView(_sectionHeader, imageViewH - 20).rightSpaceToView(_sectionHeader, 17).widthIs(122).heightIs(40);
        
        line.sd_layout.leftSpaceToView(_sectionHeader, 0).topSpaceToView(_sectionHeader, imageViewH).rightSpaceToView(_sectionHeader, 0).heightIs(minLineWidth);
        
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
        countLB.text = @"new";
        countLB.textColor = [UIColor whiteColor];
        countLB.backgroundColor = kRGB(238, 28, 37);
        countLB.textAlignment = NSTextAlignmentCenter;
        countLB.layer.cornerRadius = 10;
        countLB.layer.masksToBounds = YES;
        countLB.adjustsFontSizeToFitWidth = YES;
        countLB.font = [UIFont boldSystemFontOfSize:15];
        [_tableHeader addSubview:countLB];
        _countLB = countLB;
        
        
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
        [_titleView setTitle:@"Moments" forState:UIControlStateNormal];
        _titleView.enabled = NO;
        _titleView.frame = CGRectMake(0, 0, 300, 40);
    }
    return _titleView;
}

- (void)handleBellBtnAction {
    DiscussViewController *discussVC = [[DiscussViewController alloc] init];
    discussVC.idDictionary = self.tempDic;
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
            [self getAllMoments:self.tempDic IsNeedRefresh:NO];
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
                [self getAllMoments:self.tempDic IsNeedRefresh:NO];
            } else if (type == ExitTypeModify){
                self.setBtn.hidden = NO;
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
    self.setBtn.hidden = YES;
    [self configureNavigationItem];
    
    self.notification = nil;
    //显示缓存数据
    [self getDataBaseWithNotification:nil];
    self.tempDic = nil;
    //获取moments
    [self getAllMoments:self.tempDic IsNeedRefresh:YES];
    
    self.tableView.backgroundColor = kRGBColor(28, 37, 51);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.allowsSelection = NO;
    [Common removeExtraCellLines:self.tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    //下拉刷新
    [self handleDownRefreshAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConvertId:) name:NOTICE_KEY_NEED_REFRESH_MOMENTS object:nil];
    //处理通知
    [self handleNotificationWithBlock:^(id notification) {
        if (notification) {
            if ([notification isKindOfClass:[TT_Message class]]) {
                TT_Message *message = (TT_Message *)notification;
                if (message.message_type == 3) {
                    //如果有消息，且消息类型符合首页展示条件，则显示消息UI
                    //拉取最新moment数据
                    [self getAllMoments:self.tempDic IsNeedRefresh:NO];
                }
            }
        }
    }];
    
    //子页面有已读 需要更新
    [[NSNotificationCenter defaultCenter] addCustomObserver:self Name:NOTICE_KEY_NEED_REFRESH_MOMENTS_2 Object:nil Block:^(id  _Nullable sender) {
        [self getAllMoments:self.tempDic IsNeedRefresh:NO];
    }];
    
    //增加监听fps
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YYFPSLabel xw_addFPSLableOnWidnow];
    });
    
    //测试
    //     [self deleteAllData];
    
    
}

#pragma mark 获取Moments
- (void)getAllMoments:(NSDictionary *)requestDic IsNeedRefresh:(BOOL)isNeedRefresh{
    if (isNeedRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AllMomentsApi *projectsApi = [[AllMomentsApi alloc] init];
    projectsApi.requestArgument = requestDic;
    [projectsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.dataSource removeAllObjects];
        NSLog(@"getAllMoments:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        BOOL isShowRing = NO;
        NSInteger newsCount = 0;
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic = request.responseJSONObject[OBJ];
            NSDictionary *bannerDic = objDic[@"banner"];
            NSString *newscount = objDic[@"newscount"];
            NSArray *listArr = objDic[@"list"];
            //加载缓存
            [[CacheManager sharedInstance] saveMomentsWithBanner:bannerDic[@"url"] list:listArr notification:self.notification];
            
            for (NSDictionary *dic in listArr) {
                HomeModel *homeModel = [HomeModel modelWithDic:dic];
                [self.dataSource addObject:homeModel];
            }
            
            //未读消息个数
            newsCount = [newscount integerValue];
            if (newsCount > 0) {
                isShowRing = YES;
            }
            
            //是否是管理员
            if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsProject) {
                self.memberType = [objDic[@"member_type"] integerValue];
            } else {
                self.memberType = -1;
            }
            
            //封面
            if (kIsDictionary(objDic[@"banner"]) &&
                [[objDic[@"banner"] allKeys] count] != 0 &&
                ![Common isEmptyString:objDic[@"banner"][@"url"]]) {
                self.textLB.hidden = YES;
                self.imageView.hidden = NO;
                NSString *bannerURL = objDic[@"banner"][@"url"];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:bannerURL] placeholderImage:self.imageView.image options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image && image.size.height / image.size.width !=  kWidthHeightScale) {
                        //handle image
                        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    } else if (!image) {
                        [self showDefaultCover];
                    }
                }];
            } else {
                [self showDefaultCover];
            }
            //更多数据
            if (![Common isEmptyString:objDic[@"next"]]) {
                [self handleUpRefreshAction:objDic[@"next"]];
            }
        }
        else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
            self.setBtn.hidden = YES;
            [self.titleView setImage:nil forState:UIControlStateNormal];
            [self.titleView setTitle:@"Moments" forState:UIControlStateNormal];
        }
        if (!isShowRing) {
            UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, CGFLOAT_MIN)];
            self.tableView.tableHeaderView = tableViewHeaderView;
        } else {
            self.tableView.tableHeaderView = self.tableHeader;
            self.countLB.text = @(newsCount).stringValue;
            if (newsCount > 99) {
                self.countLB.text = @"99+";
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, CGFLOAT_MIN)];
        self.tableView.tableHeaderView = tableViewHeaderView;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 下拉刷新
- (void)handleDownRefreshAction {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAllMoments:self.tempDic IsNeedRefresh:NO];
    }];
}

#pragma mark - 上拉刷新
- (void)handleUpRefreshAction:(NSString *)tempURL {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    HTTPManager *manager = [HTTPManager manager];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)handleTapTableViewAction:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)configureNavigationItem {
    self.navigationItem.titleView = self.titleView;
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
            TTAddDiscussViewController *addDiscussVC = [[TTAddDiscussViewController alloc] initWithNibName:@"TTAddDiscussViewController" bundle:nil];
            if ([self.tempDic.allKeys containsObject:@"pid"]) {
                addDiscussVC.pidOrGid = self.tempDic[@"pid"];
            }
            addDiscussVC.addDiscussBlock = ^(NSString *pid, NSString *name) {
                [self.titleView setTitle:name forState:UIControlStateNormal];
                self.tempDic = @{@"pid":pid};
                [self getAllMoments:self.tempDic IsNeedRefresh:NO];
            };
            [Common customPushAnimationFromNavigation:self.navigationController ToViewController:addDiscussVC Type:kCATransitionMoveIn SubType:kCATransitionFromTop];
        } else if (index == 1) {
            TTAddVoteViewController *addVoteVC = [[TTAddVoteViewController alloc] initWithNibName:@"TTAddVoteViewController" bundle:nil];
            if ([self.tempDic.allKeys containsObject:@"pid"]) {
                addVoteVC.pidOrGid = self.tempDic[@"pid"];
            }
            addVoteVC.addVoteBlock = ^(NSString *pid, NSString *name) {
                [self.titleView setTitle:name forState:UIControlStateNormal];
                self.tempDic = @{@"pid":pid};
                [self getAllMoments:self.tempDic IsNeedRefresh:NO];
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
    //是否是管理员
    if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsProject) {
        if (self.memberType == 0) {
            return;
        }
    }
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            SelectBgImageVC *selectBgImageVC = [[SelectBgImageVC alloc] init];
            WeakSelf;
            selectBgImageVC.selectCircleVCBlock = ^(UIImage *selectImage, SelectBgImageVC *selectBgImageVC) {
                self.textLB.hidden = YES;
                // 获取当前使用的图片像素和点的比例
                CGFloat scale = [UIScreen mainScreen].scale;
                // 裁减图片
                CGImageRef imgR = CGImageCreateWithImageInRect(selectImage.CGImage, CGRectMake(0, 0, wself.imageView.size.width * scale, wself.imageView.size.height * scale));
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
                    NSDictionary *bannerDic = nil;
                    if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsGroup) {
                        bannerDic = @{@"medias":bannerStr,
                                      @"gid":self.tempDic[@"gid"]};
                    } else if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsProject) {
                        bannerDic = @{@"medias":bannerStr,
                                      @"pid":self.tempDic[@"pid"]};
                    } else {
                        bannerDic = @{@"medias":bannerStr};
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [self bannerUpdate:bannerDic UploadImage:uploadImg];
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
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            //修改图片
            self.textLB.hidden = YES;
            self.imageView.hidden = NO;
            self.imageView.image = uploadImg;
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

- (void)handleKeyBoard:(NSNotification *)notification {
    if (!self.currentIndexPath) {
        return;
    }
    if (self.currentIndexPath.row >= self.dataSource.count) {
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
    if (model.cellType == HomeModelCellTypeComment) {
        cell = (HomeCell *)[HomeCell cellWithTableView:tableView];
        ((HomeCell *)cell).commentBtn.indexPath = indexPath;
        ((HomeCell *)cell).commentBtn.isShow = YES;
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
    return kScreenWidth * kWidthHeightScale + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [UIScreen mainScreen].scale;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - HomeCellDelegate
- (void)clickCommentBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)currentIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//点击项目名称
- (void)clickProjectBtn:(TT_Project *)project {
    self.setBtn.hidden = NO;
    self.imageView.userInteractionEnabled = YES;
    self.tempProject = project;
    [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
    [self.titleView setImage:nil forState:UIControlStateNormal];
    [self.titleView setTitle:project.name forState:UIControlStateNormal];
    self.tempDic = @{@"pid":project.project_id};
    [self getAllMoments:@{@"pid":project.project_id} IsNeedRefresh:NO];//pid 项目id
}

#pragma mark - HomeVoteCellDeleagte
//点击项目名称
- (void)clickVoteProjectBtn:(TT_Project *)project {
    self.setBtn.hidden = NO;
    self.imageView.userInteractionEnabled = YES;
    self.tempProject = project;
    [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
    [self.titleView setImage:nil forState:UIControlStateNormal];
    [self.titleView setTitle:project.name forState:UIControlStateNormal];
    self.tempDic = @{@"pid":project.project_id};
    [self getAllMoments:@{@"pid":project.project_id} IsNeedRefresh:NO];//pid 项目id
}


- (void)clickVoteBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickVoteSuccess:(NSIndexPath *)indexPath homeModel:(HomeModel *)model {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.dataSource insertObject:model atIndex:indexPath.row];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeCustomObserver:self Name:NOTICE_KEY_MESSAGE_COMING Object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_KEY_NEED_REFRESH_MOMENTS_2 object:nil];
}

#pragma mark - 分组或者项目Moments
- (void)handleConvertId:(NSNotification *)notification {
    self.imageView.image = kImage(@"img_cover");
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *parameterDic = nil;
        BOOL isLoading = NO;
        if (notification.object && [notification.userInfo[@"IsGroup"] intValue] == 1) {//分组
            parameterDic = @{@"gid":[notification.object group_id]};
            self.setBtn.hidden = NO;
            self.imageView.userInteractionEnabled = YES;
            [self.titleView setImage:kImage(@"icon_moments") forState:UIControlStateNormal];
            self.titleView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [self.leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
            [self.setBtn setTitle:@"分组设置" forState:UIControlStateNormal];
            
            self.tempProject = nil;
            self.tempGroup = notification.object;
            isLoading = YES;
        }else if (notification.object && [notification.userInfo[@"IsGroup"] intValue] == 0) {//项目
            //加载数据库数据
            [self getDataBaseWithNotification:notification];
            
            parameterDic = @{@"pid":[notification.object project_id]};
            self.setBtn.hidden = NO;
            self.imageView.userInteractionEnabled = YES;
            
            [self.titleView setImage:nil forState:UIControlStateNormal];
            [self.leftBtn setImage:kImage(@"icon_back") forState:UIControlStateNormal];
            [self.setBtn setTitle:@"项目设置" forState:UIControlStateNormal];
            
            self.tempProject = notification.object;
            self.tempGroup = nil;
            isLoading = YES;
        } else {//主页
            //加载数据库数据
            [self getDataBaseWithNotification:notification];
            
            self.setBtn.hidden = YES;
            self.imageView.userInteractionEnabled = YES;
            
            [self.leftBtn setImage:kImage(@"icon_sidebar") forState:UIControlStateNormal];
            self.tempProject = nil;
            self.tempGroup = nil;
        }
        self.tempDic = parameterDic;
        self.notification = notification;
        [self getAllMoments:parameterDic IsNeedRefresh:isLoading];
        [self.titleView setTitle:notification.userInfo[@"Title"] forState:UIControlStateNormal];
    });
}

//MARK: - 当前展示的是否是项目、分组、还是所有
- (ECurrentStatus)isProejctOrGroupOrAllByCurrently {
    ECurrentStatus currentStatus;
    if(self.tempDic) {
        if (![self.tempDic.allKeys containsObject:@"pid"] &&
            ![self.tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsAll;
        } else if ([self.tempDic.allKeys containsObject:@"pid"] &&
                   ![self.tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsProject;
        } else if (![self.tempDic.allKeys containsObject:@"pid"] &&
                   [self.tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsGroup;
        } else {
            currentStatus = ECurrentIsAll;
        }
    } else {
        currentStatus = ECurrentIsAll;
    }
    return currentStatus;
}

- (void)showDefaultCover {
    if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsProject) {
        //只展示project
        self.textLB.hidden = YES;
        self.imageView.hidden = NO;
        self.imageView.image = kImage(@"img_cover");
        if (self.memberType == 1) {
            //管理员
            self.textLB.hidden = NO;
            self.textLB.text = @"轻触设置项目封面";
        }
    }
    else if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsGroup) {
        //只展示分组的
        self.textLB.hidden = NO;
        self.textLB.text = @"轻触设置分组封面";
        self.imageView.hidden = NO;
        self.imageView.image = kImage(@"img_cover");
    }
    else if ([self isProejctOrGroupOrAllByCurrently] == ECurrentIsAll) {
        //所有moment
        self.textLB.hidden = NO;
        self.textLB.text = @"轻触设置Moments封面";
        self.imageView.hidden = NO;
        self.imageView.image = kImage(@"img_cover");
    }
}

- (void)getDataBaseWithNotification:(NSNotification *)notification {
    if (![Common isEmptyArr:self.dataSource]) {
         [self.dataSource removeAllObjects];
    }
    Moments *moment = [[CacheManager sharedInstance] selectMomentsFromDataBaseWithNotification:notification];;
    NSLog(@"moment.bannerUrl---%@", moment.bannerUrl);
    if (![Common isEmptyString:moment.bannerUrl]) {
        self.textLB.hidden = YES;
        self.imageView.hidden = NO;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:moment.bannerUrl] placeholderImage:kImage(@"img_cover")];
    }
    [self.dataSource setArray:moment.list];
    [self.tableView reloadData];
}



@end
