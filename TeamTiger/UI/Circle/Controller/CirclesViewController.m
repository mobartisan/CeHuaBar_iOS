//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "AKPickerView.h"
#import "CCDraggableConfig.h"
#import "CCDraggableContainer.h"
#import "CirclesViewController.h"
#import "CustomCardView.h"
#import "HomeViewController.h"
#import "NetworkManager.h"
#import "TTAddProjectViewController.h"
#import "TTMyProfileViewController.h"
#import "TTTabBarViewController.h"
#import "UIButton+HYBHelperBlockKit.h"
#import "UIViewController+MMDrawerController.h"
#import "UserInfoView.h"


@interface CirclesViewController ()<AKPickerViewDataSource, AKPickerViewDelegate,CCDraggableContainerDataSource,
CCDraggableContainerDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) UserInfoView *userInfoView;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UILabel *offerLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *addCircleBtn;

@property (nonatomic, strong) CCDraggableContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) NSInteger lastSelectItem;
@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) CGPoint orignPoint;
@end

@implementation CirclesViewController
- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.titles = @[@"所有项目",@"工作牛",@"易会",@"MPP",@"营配"];
    
    self.dataSources = [NSMutableArray array];
    
    for (int i = 0; i < self.titles.count; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"image_%d.jpg",i + 1],
                               @"title" : [NSString stringWithFormat:@"Page %d",i + 1]};
        [self.dataSources addObject:dict];
    }
    
    //    self.homeVCs = [NSMutableArray array];
    //    for (NSString *title in self.titles) {
    //        HomeViewController *homeVC = [[HomeViewController alloc] init];
    //        homeVC.title = title;
    //        [self.homeVCs addObject:homeVC];
    //    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    //配置网络
    //    [NetworkManager configerNetworking];
    //
    //    Api1 *api1 = [[Api1 alloc] init];
    //    api1.cacheInvalidTime = 60;//需要缓存
    //    api1.requestArgument = @{@"lat":@"34.345",@"lng":@"113.678"};
    //    LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self];
    //    [api1 addAccessory:accessary];
    //    [api1 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
    //        NSLog(@"%@",request.responseJSONObject);
    //    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
    //        NSLog(@"%@",error.description);
    //    }];
    
    //
    //    UIButton *btn = [UIButton hyb_buttonWithTitle:@"TEST" superView:self.view constraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.view.mas_centerX);
    //        make.centerY.mas_equalTo(self.view.mas_centerY);
    //        make.width.mas_equalTo(100);
    //        make.height.mas_equalTo(100);
    //    } touchUp:^(UIButton *sender) {
    //        TTSettingViewController *settingVC = [[TTSettingViewController alloc] init];
    //        [self.navigationController pushViewController:settingVC animated:YES];
    //    }];
    //    btn.backgroundColor = [UIColor redColor];
    
    // 添加清扫手势 全屏滑动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.view addGestureRecognizer:pan];
    
    [self.view addSubview:self.container];
    
    [self.view addSubview:self.userInfoView];
    
    [self.view addSubview:self.pickerView];
    
    [self.view addSubview:self.addCircleBtn];
    [self layoutSubviews];
}

-(void)layoutSubviews{
    WeakSelf;
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(44);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view);
        make.top.equalTo(wself.userInfoView.mas_bottom);
        make.bottom.equalTo(wself.view).offset(-100);
        make.width.mas_equalTo(Screen_Width * 0.2);
    }];
    
    [self.addCircleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view);
        make.top.equalTo(wself.pickerView.mas_bottom);
        make.width.mas_equalTo(Screen_Width * 0.2);
        make.height.mas_equalTo(100);
    }];
    
    //    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(wself.view).offset(-20.0);
    //        make.centerY.equalTo(wself.view);
    //        make.height.equalTo(@400);
    //        make.width.equalTo(@280);
    //    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    [self.container panGestureHandle:gesture];
}
#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */
-(void)addCircleAction:(UIButton *)button{
    TTAddProjectViewController *addProjectVC = [[TTAddProjectViewController alloc] init];
    TTBaseNavigationController *navi = [[TTBaseNavigationController alloc] initWithRootViewController:addProjectVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"%@", self.titles[item]);
    if (self.lastSelectItem == item) {
        return;
    }
    
    if (self.lastSelectItem < item) {
        [self.container removeFormDirection:CCDraggableDirectionLeft];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.container reloadDataWithLoadIndex:item animated:NO];
        });
    } else
    {
        [self.container reloadDataWithLoadIndex:item animated:YES];
    }
    
    
    self.lastSelectItem = item;
    
    //    TTSettingViewController *settingVC = [[TTSettingViewController alloc] init];
    //    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - getter and setter
-(UIButton *)addCircleBtn{
    if (!_addCircleBtn) {
        _addCircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCircleBtn setImage:[UIImage imageNamed:@"circle-add"] forState:UIControlStateNormal];
        //        [_addCircleBtn setBackgroundImage:[UIImage imageNamed:@"group-detail-createmeetingIcon"] forState:UIControlStateNormal];
        //        [_addCircleBtn setBackgroundImage:[UIImage imageNamed:@"group-detail-createmeetingIcon"] forState:UIControlStateHighlighted];
        [_addCircleBtn addTarget:self action:@selector(addCircleAction:) forControlEvents:UIControlEventTouchUpInside];
        _addCircleBtn.backgroundColor = [UIColor clearColor];
    }
    return _addCircleBtn;
}

//- (UILabel *)offerLab {
//    if (!_offerLab) {
//        _offerLab = [[UILabel alloc] init];
//        _offerLab.textAlignment = NSTextAlignmentCenter;
//        _offerLab.text = @"网络不给力，图片下载失败";
//        _offerLab.font = [UIFont boldSystemFontOfSize:20];
//        _offerLab.textColor = [UIColor whiteColor];
//        _offerLab.backgroundColor = [UIColor clearColor];
//    }
//    return _offerLab;
//}
//
//- (UIImageView *)headImgV {
//    if (!_headImgV) {
//        _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//        _headImgV.layer.masksToBounds = YES;
//        _headImgV.layer.cornerRadius = _headImgV.hyb_height * 0.5;
//        _headImgV.backgroundColor = [UIColor clearColor];
//        _headImgV.image = kImageForHead;
//    }
//    return _headImgV;
//}

- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = LoadFromNib(@"UserInfoView");
        [_userInfoView userInfoViewWithData:nil];
        WeakSelf;
        _userInfoView.clickBlock = ^(UserInfoView *view){
            //
            TTMyProfileViewController *myProfileVC = [[TTMyProfileViewController alloc] init];
            TTBaseNavigationController *navi = [[TTBaseNavigationController alloc] initWithRootViewController:myProfileVC];
            [wself presentViewController:navi animated:YES completion:nil];
        };
    }
    return _userInfoView;
}

- (AKPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AKPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        _pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        _pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _pickerView.highlightedBackGroundColor = [UIColor clearColor];
        _pickerView.interitemSpacing = 20.0;
        _pickerView.fisheyeFactor = 0.001;
        _pickerView.pickerViewStyle = AKPickerViewStyleFlat;
        _pickerView.maskDisabled = false;
        [_pickerView reloadData];
    }
    return _pickerView;
}

- (CCDraggableContainer *)container {
    if (!_container) {
        _container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, (Screen_Height*0.5)/2, Screen_Width * 0.60, Screen_Height*0.5) style:CCDraggableStyleUpOverlay];
        //        _container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 0, Screen_Width * 0.60, Screen_Height) style:CCDraggableStyleUpOverlay];
        _container.delegate = self;
        _container.dataSource = self;
        [_container reloadData];
    }
    return _container;
}

//- (NSMutableArray *)dataSources {
//    if (!_dataSources) {
//        _dataSources = [NSMutableArray array];
//
//        for (int i = 0; i < 9; i++) {
//            NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"image_%d.jpg",i + 1],
//                                   @"title" : [NSString stringWithFormat:@"Page %d",i + 1]};
//            [_dataSources addObject:dict];
//        }
//    }
//    return _dataSources;
//}

#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    CustomCardView *cardView = [[CustomCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView installData:[_dataSources objectAtIndex:index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    [self.pickerView scrollToItem:draggableContainer.loadedIndex % _dataSources.count animated:YES];
    
    //    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        //        self.disLikeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        //        self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickCard" object:@(didSelectIndex)];
    NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
    didSelectIndex = didSelectIndex % (self.dataSources.count);
    
    [CirclesManager sharedInstance].selectIndex = didSelectIndex;
//    TTTabBarViewController *mainTab = (TTTabBarViewController *)self.mm_drawerController.centerViewController;
//
//    mainTab.selectedIndex = didSelectIndex;
    //    if (self.homeVCs[didSelectIndex] != nav.topViewController) {
    //        [nav popViewControllerAnimated:NO];
    //        [nav pushViewController:self.homeVCs[didSelectIndex] animated:NO];
    //    }
    
    TTBaseNavigationController *mainNav = (TTBaseNavigationController *)self.mm_drawerController.centerViewController;
    HomeViewController *homeVC = (HomeViewController *)mainNav.topViewController;
    //刷新数据
    [homeVC reloadWithData:[CirclesManager sharedInstance].selectCircle];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    
    [draggableContainer reloadData];
}

@end
