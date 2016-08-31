//
//  CirclesVC.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/15.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CirclesVC.h"
#import "JZNavigationExtension.h"
#import "UserInfoView.h"
#import "TTMyProfileViewController.h"
#import "CirclesItemModel.h"
#import "CirclesItemCell.h"
#import "ChooseTag.h"
#import "TTAddProjectViewController.h"

// Controllers

// Model

// Views
//#define <#macro#> <#value#>

@interface CirclesVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIBarButtonItem *addCirclesItem;
@property(nonatomic,strong) UIImageView *headImgV;

@property (nonatomic, strong) UserInfoView *userInfoView;
@property (nonatomic, strong) ChooseTag *chooseTagView;
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *circles;
@property (nonatomic, strong) NSMutableArray *data;
@end
#pragma mark - View Controller LifeCyle
@implementation CirclesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [Common customPopAnimationFromNavigation:wself.navigationController Type:kCATransitionPush SubType:kCATransitionFromRight];
    }];
    self.navigationItem.rightBarButtonItem = self.addCirclesItem;
    //    self.navigationController.jz_navigationBarBackgroundAlpha = 0;
    self.navigationController.jz_navigationBarBackgroundHidden = YES;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    [self.view addSubview:self.headImgV];
    [self.headImgV addSubview:self.userInfoView];
    [self.view addSubview:self.chooseTagView];
    [self.view addSubview:self.tableView];
    [self setupModels];
    [self layoutSubViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Override

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Initial Methods

-(void)layoutSubViews {
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kDistanceToHSide);
        make.right.equalTo(self.view.mas_right).offset(-kDistanceToHSide);
        make.top.equalTo(self.view).offset(default_NavigationHeight);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.24);
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgV);
        make.bottom.equalTo(self.headImgV);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(70);
    }];
    
    [self.chooseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgV.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.24);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseTagView.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)setupModels {
    self.circles = [CirclesManager sharedInstance].circles;
    for (NSString *title in self.circles) {
        
        NSString *colorStr = [NSString stringWithUTF8String:kColorAr[arc4random_uniform(6)]];
        CirclesItemModel *item = [[CirclesItemModel alloc] init];
        item.title = title;
        item.pointColor = colorStr;
        
        [self.data addObject:item];
    }
}

#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    CirclesItemCell *cell = [CirclesItemCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    CirclesItemModel *item = self.data[indexPath.row];
    [cell setData:item];
    cell.lastRowInSection =  (self.data.count - 1 == indexPath.row);
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    // 2.模型数据
    //    TTCommonGroup *group = self.data[indexPath.section];
    //    TTCommonItem *item = group.items[indexPath.row];
    //
    //    //    if (self.selectCircleVCBlock) {
    //    //        self.selectCircleVCBlock(self.circles[indexPath.section], self);
    //    //    }
    //    //    [[CacheManager sharedInstance] setObject:item.title ForKey:TTSelectCircle_Cache_Key];
    ////    [CirclesManager sharedInstance].selectIndex = indexPath.section;
    ////    [self.navigationController popViewControllerAnimated:YES];
    //
    //    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
    //        item.option();
    //    } else if ([item isKindOfClass:[TTCommonArrowItem class]]) { // 箭头
    //        TTCommonArrowItem *arrowItem = (TTCommonArrowItem *)item;
    //
    //        // 如果没有需要跳转的控制器
    //        if (arrowItem.destVcClass == nil) return;
    //
    //        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
    //        vc.title = arrowItem.title;
    //        [self.navigationController pushViewController:vc  animated:YES];
    //    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 20;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    TTCommonGroup *group = self.data[section];
//    return group.header;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    TTCommonGroup *group = self.data[section];
//    return group.footer;
//}


#pragma mark - Privater Methods
-(void)addCirclesAction {
    NSLog(@"创建新的圈子");
    TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
    TTBaseNavigationController *baseNav = [[TTBaseNavigationController alloc] initWithRootViewController:addProfileVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
}

#pragma mark - Setter Getter Methods
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

-(UIImageView *)headImgV {
    if (!_headImgV) {
        //        _headImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_1"]];
        _headImgV = [[UIImageView alloc] init];
        //        _headImgV.image = [UIImage imageNamed:@"image_4.jpg"];
        //        _headImgV.contentMode = UIViewContentModeCenter;
        _headImgV.clipsToBounds = YES;
        _headImgV.backgroundColor = [UIColor blueColor];
        _headImgV.userInteractionEnabled = YES;
    }
    return _headImgV;
}

-(ChooseTag *)chooseTagView {
    if (!_chooseTagView) {
        _chooseTagView = [[ChooseTag alloc] init];
        _chooseTagView.tags =  @[@[@"tag",@"tag1",@"tag2",@"tag3",@"tag4"],@[@"tag5",@"tag6",@"tag7",@"tag8"]];
    }
    return _chooseTagView;
}

-(UIBarButtonItem *)addCirclesItem{
    if (!_addCirclesItem) {
        _addCirclesItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCirclesAction)];
    }
    return _addCirclesItem;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end