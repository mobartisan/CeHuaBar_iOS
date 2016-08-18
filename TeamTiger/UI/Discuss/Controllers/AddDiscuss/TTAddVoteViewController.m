//
//  TTAddVoteViewController.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTAddVoteViewController.h"
#import "TTCommonCell.h"
#import "TTCommonItem.h"
#import "TTCommonGroup.h"
#import "TTCommonArrowItem.h"
#import "TTCommonTextViewItem.h"
#import "TTCommonCustomViewItem.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "AddImageViewController.h"
#import "SelectPhotosManger.h"
#import "SelectCircleViewController.h"
#import "IQKeyboardManager.h"
#import "AddImageView.h"
// Controllers

// Model

// Views
//#define <#macro#> <#value#>

@interface TTAddVoteViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AddImageView *addImageView;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end
#pragma mark - View Controller LifeCyle
@implementation TTAddVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"发起投票";
    self.isSelectOriginalPhoto = YES;
    [Common removeExtraCellLines:self.tableView];
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [Common customPopAnimationFromNavigation:wself.navigationController Type:kCATransitionReveal SubType:kCATransitionFromBottom];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77;
    //    self.tableView.rowHeight = 77;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 0.添加数据
    
    [self setupGroup0];
    [self setupGroup1];
//    [self setupGroup2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[SelectPhotosManger sharedInstance] cleanSelectAssets];
    [[SelectPhotosManger sharedInstance] cleanSelectPhotoes];
}
/**
 *  第0组数据
 */
- (void)setupGroup0
{
    
    TTCommonItem *voteName = [TTCommonTextViewItem itemWithTitle:@"名称" textViewPlaceholder:@"请输入投票名称"];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = @[voteName];
    [self.data addObject:group];
}

/**
 *  第1组数据
 */
- (void)setupGroup1
{
    AddImageView *customView0 = [AddImageView addImageViewWithType:AddImageViewVoteWithTitle];
    AddImageView *customView1 = [AddImageView addImageViewWithType:AddImageViewVote];
    AddImageView *customView2 = [AddImageView addImageViewWithType:AddImageViewVote];
    //    self.addImageView = customView;
    TTCommonItem *attachment0 = [TTCommonCustomViewItem itemWithCustomView:customView0];
    TTCommonItem *attachment1 = [TTCommonCustomViewItem itemWithCustomView:customView1];
    TTCommonItem *attachment2 = [TTCommonCustomViewItem itemWithCustomView:customView2];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = @[attachment0, attachment1, attachment2];
    [self.data addObject:group];
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TTCommonGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    TTCommonCell *cell = [TTCommonCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    TTCommonGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.lastRowInSection =  (group.items.count - 1 == indexPath.row);
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    TTCommonGroup *group = self.data[indexPath.section];
    TTCommonItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[TTCommonArrowItem class]]) { // 箭头
        TTCommonArrowItem *arrowItem = (TTCommonArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TTCommonGroup *group = self.data[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    TTCommonGroup *group = self.data[section];
    return group.footer;
}


#pragma mark - Override

#pragma mark - Initial Methods

#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource


#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end