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
{
    NSString *_text;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AddImageView *addImageView;
@property(nonatomic,strong) UIButton *startMomentBtn;
@property (nonatomic, strong) TTCommonArrowItem *tagItem;

@property (strong, nonatomic) TTCommonItem *tempDescribe;

@end

@implementation TTAddDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起讨论";
    [Common removeExtraCellLines:self.tableView];
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [Common customPopAnimationFromNavigation:self.navigationController Type:kCATransitionReveal SubType:kCATransitionFromBottom];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 0.添加数据
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tagItem.subtitle = ((NSString *)([[CirclesManager sharedInstance] selectCircle][@"name"]));
    [self.tableView reloadData];
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
    TTCommonItem *tag = [TTCommonArrowItem itemWithTitle:@"标签" subtitle:[[CirclesManager sharedInstance] selectCircle][@"name"] destVcClass:[SelectCircleViewController class]];
    self.tagItem = (TTCommonArrowItem *)tag;
    TTCommonItem *describe = [TTCommonTextViewItem itemWithTitle:@"描述" textViewPlaceholder:@"请输入描述"];
    self.tempDescribe = describe;
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
    cell.actionBlock = ^ (NSString *text) {
        _text = text;
    };
    
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
        [_startMomentBtn setTitleColor:[Common colorFromHexRGB:@"2EC9CA"] forState:UIControlStateNormal];
        setViewCornerAndBorder(_startMomentBtn, 8);
        [_startMomentBtn setTitle:@"创建" forState:UIControlStateNormal];
        [_startMomentBtn addTarget:self action:@selector(actionStartMoment) forControlEvents:UIControlEventTouchUpInside];
        _startMomentBtn.backgroundColor = [UIColor clearColor];
    }
    return _startMomentBtn;
}

#warning to do
- (void)actionStartMoment {
    id picArr = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:@"Moment"];
    
    if ([Common isEmptyArr:picArr] && [Common isEmptyString:_text]) {
        [super showText:@"请输入描述或添加图片" afterSeconds:1.0];
        return;
    }
    NSMutableArray *mediasArr = [NSMutableArray array];
    if ([Common isEmptyArr:picArr] && ![Common isEmptyString:_text]) {//没有图片,有文字
        [self creatMomentAction:mediasArr text:_text];
    }else if (![Common isEmptyArr:picArr] && [Common isEmptyString:_text]) {//有图片无文字
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [QiniuUpoadManager uploadImages:picArr progress:^(CGFloat progress) {
                
            } success:^(NSArray *urls) {
                for (NSString *url in urls) {
                    NSDictionary *dic = @{@"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",//用户ID
                                          @"type":@0,
                                          @"from":@1,
                                          @"url":url};
                    [mediasArr addObject:dic];
                }
                [self creatMomentAction:mediasArr text:@""];
                
            } failure:^(NSError *error) {
                [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
            }];
        });
    }else if (![Common isEmptyArr:picArr] && ![Common isEmptyString:_text]) {//有图片有文字
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [QiniuUpoadManager uploadImages:picArr progress:^(CGFloat progress) {
                
            } success:^(NSArray *urls) {
                for (NSString *url in urls) {
                    NSDictionary *dic = @{@"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",//用户ID
                                          @"type":@0,
                                          @"from":@1,
                                          @"url":url};
                    [mediasArr addObject:dic];
                }
                [self creatMomentAction:mediasArr text:_text];
                
            } failure:^(NSError *error) {
                [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
            }];
        });
    }
}

- (void)creatMomentAction:(NSArray *)mediasArr text:(NSString *)text{
    NSData *data = [NSJSONSerialization dataWithJSONObject:mediasArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *urlsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    MomentCreateApi *momentCreatApi = [[MomentCreateApi alloc] init];
    momentCreatApi.requestArgument = @{@"text":text,
                                       @"pid":((NSString *)([[CirclesManager sharedInstance] selectCircle][@"_id"])),//pid  项目id
                                       @"type":@1,
                                       @"medias":urlsStr};
    [momentCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [super showText:@"发起讨论成功" afterSeconds:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            //创建失败
            [super showHudWithText:request.responseJSONObject[MSG]];
            [super hideHudAfterSeconds:3.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}


@end
