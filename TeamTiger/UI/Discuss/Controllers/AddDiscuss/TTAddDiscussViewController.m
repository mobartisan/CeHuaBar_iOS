//
//  TTAddDiscussViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTAddDiscussViewController.h"
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
#import "TTAddVoteViewController.h"

@interface TTAddDiscussViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AddImageView *addImageView;
@property(nonatomic,strong) UIButton *startMomentBtn;
@property (nonatomic, strong) TTCommonArrowItem *tagItem;
@end

@implementation TTAddDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起讨论";
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
    [self setupGroup2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tagItem.subtitle = [[CirclesManager sharedInstance] selectCircle];
//    [self.data removeAllObjects];
//
//    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
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
    TTCommonItem *tag = [TTCommonArrowItem itemWithTitle:@"标签" subtitle:[[CirclesManager sharedInstance] selectCircle] destVcClass:[SelectCircleViewController class]];
    self.tagItem = (TTCommonArrowItem *)tag;
    TTCommonItem *describe = [TTCommonTextViewItem itemWithTitle:@"描述" textViewPlaceholder:@"请输入描述"];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithArray:@[tag,describe]];
    [self.data addObject:group];
}

/**
 *  第1组数据
 */
- (void)setupGroup1
{

    AddImageView *customView = [AddImageView addImageViewWithType:AddImageViewDefual AndOption:@"Moment"];
    TTCommonItem *attachment = [TTCommonCustomViewItem itemWithCustomView:customView];
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithArray:@[attachment]];
    [self.data addObject:group];
}

- (void)setupGroup2
{

    UIView *startView = [[UIView alloc] init];
    startView.backgroundColor = kColorForBackgroud;

    [startView addSubview:self.startMomentBtn];
    [self.startMomentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startView);
        make.left.equalTo(startView).offset(8);
        make.width.mas_equalTo(Screen_Width-16);
        make.height.mas_equalTo(50);
    }];
    TTCommonItem *startBtnItem = [TTCommonCustomViewItem itemWithCustomView:startView];
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithObjects:startBtnItem,nil];
    [self.data addObject:group];
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}


#pragma mark - Table view data source
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


-(UIButton *)startMomentBtn{
    if (!_startMomentBtn) {
        _startMomentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _startMomentBtn.frame = CGRectMake(0, 0, Screen_Width - 10, 44);
        [_startMomentBtn setTitleColor:[Common colorFromHexRGB:@"2EC9CA"] forState:UIControlStateNormal];
        setViewCornerAndBorder(_startMomentBtn, 8);
        [_startMomentBtn setTitle:@"创建" forState:UIControlStateNormal];
        //        [_startMomentBtn setBackgroundImage:[UIImage imageNamed:@"group-detail-createmeetingIcon"] forState:UIControlStateNormal];
        //        [_startMomentBtn setBackgroundImage:[UIImage imageNamed:@"group-detail-createmeetingIcon"] forState:UIControlStateHighlighted];
        [_startMomentBtn addTarget:self action:@selector(actionStartMoment) forControlEvents:UIControlEventTouchUpInside];
        _startMomentBtn.backgroundColor = [UIColor clearColor];
        //        _startMeetingBtn.bounds = (CGRect){CGPointZero, _startMeetingBtn.currentBackgroundImage.size};
    }
    return _startMomentBtn;
}

- (void)actionStartMoment {
#warning TO DO
    id picArr = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:@"Moment"];
    NSLog(@"%@", picArr);
    NSDictionary *dic = @{@"cellType":@"0",
                          @"Id":@"0001",
                          @"iconImV":@"1",
                          @"name":@"唐小旭",
                          @"project":@"工作牛",
                          @"content":@"测试数据测试数据测试数据测试数据",
                          @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_4.jpg", @"image_4.jpg"],
                          @"time":@"7月17日 9:45",
                          @"comment":@[]};
}

@end
