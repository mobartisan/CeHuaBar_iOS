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
#import "MMAlertView.h"
// Controllers

// Model

// Views
//#define <#macro#> <#value#>
static const int STR_OPTION_MAX = 7;
static const char* kOptionStr[STR_OPTION_MAX] = {
    "A", "B", "C", "D", "E","F", "G"};
@interface TTAddVoteViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AddImageView *addImageView;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, assign) NSInteger optionIndex;
@end
#pragma mark - View Controller LifeCyle
@implementation TTAddVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"发起投票";
    self.optionIndex = 0;
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
    group.items = [NSMutableArray arrayWithArray: @[voteName]];
    [self.data addObject:group];
}

/**
 *  第1组数据
 */
- (void)setupGroup1
{
    NSString *Option0 = [NSString stringWithUTF8String:kOptionStr[self.optionIndex++]];
    NSString *Option1 = [NSString stringWithUTF8String:kOptionStr[self.optionIndex++]];
    NSString *Option2 = [NSString stringWithUTF8String:kOptionStr[self.optionIndex++]];
    AddImageView *customView0 = [AddImageView addImageViewWithType:AddImageViewVoteWithTitle AndOption:Option0];
    AddImageView *customView1 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:Option1];
    AddImageView *customView2 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:Option2];
    //    self.addImageView = customView;
    TTCommonItem *attachment0 = [TTCommonCustomViewItem itemWithCustomView:customView0];
    TTCommonItem *attachment1 = [TTCommonCustomViewItem itemWithCustomView:customView1];
    TTCommonItem *attachment2 = [TTCommonCustomViewItem itemWithCustomView:customView2];
    
    TTCommonItem *addOption = [TTCommonCustomViewItem itemWithCustomView:[self addOptionView]];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithObjects:attachment0,attachment1,attachment2,addOption,nil];
    [self.data addObject:group];
}

- (UIView *)addOptionView {
    UIView *addOptionView = [[UIView alloc] init];
    addOptionView.backgroundColor = [UIColor clearColor];
    
    UIButton *addOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addOptionBtn.frame = CGRectMake(0, 0, 30, 100);
    [addOptionBtn setImage:kImage(@"icon_add") forState:UIControlStateNormal];
    addOptionBtn.tintColor = [UIColor whiteColor];
//    [addOptionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [addOptionBtn addTarget:self action:@selector(addOptionBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    [addOptionView addSubview:addOptionBtn];
    [addOptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addOptionView);
        make.left.equalTo(addOptionView).offset(kDistanceToHSide);
//        make.top.equalTo(addOptionView).offset(kDistanceToVSide);
//        make.bottom.equalTo(addOptionView).offset(-kDistanceToVSide);
    }];
    return addOptionView;
}

- (void)addOptionBtnAction {
    NSLog(@" addOption Click");
    if (self.optionIndex < STR_OPTION_MAX) {
        NSString *option = [NSString stringWithUTF8String:kOptionStr[self.optionIndex++]];
        AddImageView *customView0 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:option];
        //    self.addImageView = customView;
        TTCommonItem *attachment0 = [TTCommonCustomViewItem itemWithCustomView:customView0];
        
        
        TTCommonGroup *group = [self.data lastObject];
        NSMutableArray *items = group.items;
        [items insertObject:attachment0 atIndex:items.count-1];
        
        //    [self.tableView reloadData];
        [self.tableView beginUpdates];
        NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:group.items.count-1 inSection:1]];
        [self.tableView insertRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:group.items.count-2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:group.items.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    else {
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"只能设置7个选项."];
        alertView.attachedView = self.view;
        alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
        alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
        [alertView showWithBlock:nil];
    }
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
    TTCommonCell *cell = [TTCommonCell cellWithTableView:tableView isReuse:NO];
    
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