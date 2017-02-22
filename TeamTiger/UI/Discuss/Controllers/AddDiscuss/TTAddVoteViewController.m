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
#import "SelectOptionTypeVC.h"
#import "IQKeyboardManager.h"
#import "AddImageView.h"
#import "MMAlertView.h"

static const int STR_OPTION_MAX = 9;
static const char* kOptionStr[STR_OPTION_MAX] = {
    "A", "B", "C", "D", "E","F", "G", "H", "I"};
@interface TTAddVoteViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//{
//    NSString *_text;
//}
@property (nonatomic, strong) NSString *text;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AddImageView *addImageView;
@property(nonatomic,strong) UIButton *startMomentBtn;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, assign) NSInteger optionIndex;

@property (nonatomic, strong) TTCommonArrowItem *tagItem;
@property (nonatomic, strong) TTCommonArrowItem *optionTypeItem;


@end
#pragma mark - View Controller LifeCyle
@implementation TTAddVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起投票";
    self.optionIndex = 0;
    self.isSelectOriginalPhoto = YES;
    [Common removeExtraCellLines:self.tableView];
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        //删除图片缓存
        [[SelectPhotosManger sharedInstance] cleanSelectAssets];
        [[SelectPhotosManger sharedInstance] cleanSelectPhotoes];
        [Common customPopAnimationFromNavigation:wself.navigationController Type:kCATransitionReveal SubType:kCATransitionFromBottom];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77;
    //    self.tableView.rowHeight = 77;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //定位当前是第几个项目
    if (![Common isEmptyString:self.pidOrGid]) {
        CirclesManager *circleManager = [CirclesManager sharedInstance];
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject[@"_id"] isEqualToString:self.pidOrGid];
        }];
        NSArray *results = [circleManager.circles filteredArrayUsingPredicate:predicate];
        if (results && results.firstObject) {
            circleManager.selectIndex = [circleManager.circles indexOfObject:results.firstObject];
        }
    }
    // 0.添加数据
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tagItem.subtitle = [[CirclesManager sharedInstance] selectCircle][@"name"];
    
    OptionType optionType = [CirclesManager sharedInstance].optionType;
    
    
    self.optionTypeItem.subtitle = optionType? @"多选":@"单选";
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
    TTCommonItem *tag = [TTCommonArrowItem itemWithTitle:@"项目" subtitle:[[CirclesManager sharedInstance] selectCircle][@"name"] destVcClass:[SelectCircleViewController class]];
    self.tagItem = (TTCommonArrowItem *)tag;
    TTCommonItem *describe = [TTCommonTextViewItem itemWithTitle:@"内容" textViewPlaceholder:@"请输入内容"];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithArray:@[tag,describe]];
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
    customView0.textView.userInteractionEnabled = NO;
    AddImageView *customView1 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:Option1];
    customView1.textView.userInteractionEnabled = NO;
    AddImageView *customView2 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:Option2];
    customView2.textView.userInteractionEnabled = NO;

    //    self.addImageView = customView;
    TTCommonItem *attachment0 = [TTCommonCustomViewItem itemWithCustomView:customView0];
    TTCommonItem *attachment1 = [TTCommonCustomViewItem itemWithCustomView:customView1];
    TTCommonItem *attachment2 = [TTCommonCustomViewItem itemWithCustomView:customView2];
    
    TTCommonItem *addOption = [TTCommonCustomViewItem itemWithCustomView:[self addOptionView]];
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithObjects:attachment0,attachment1,attachment2,addOption,nil];
    [self.data addObject:group];
}

- (void)setupGroup2
{
    TTCommonItem *tag = [TTCommonArrowItem itemWithTitle:@"投票类型" subtitle:@"单选" destVcClass:[SelectOptionTypeVC class]];
    self.optionTypeItem = (TTCommonArrowItem *)tag;
    
    TTCommonGroup *group = [[TTCommonGroup alloc] init];
    group.items = [NSMutableArray arrayWithArray:@[tag]];
    [self.data addObject:group];
}

- (void)setupGroup3
{
    //    self.addImageView = customView;
    UIView *startView = [[UIView alloc] init];
    startView.backgroundColor = [UIColor clearColor];

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



- (UIView *)addOptionView {
    UIView *addOptionView = [[UIView alloc] init];
    addOptionView.backgroundColor = [UIColor clearColor];
    
    UIButton *addOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addOptionBtn.frame = CGRectMake(0, 0, 30, 100);
    [addOptionBtn setTitle:@"添加更多选项   " forState:UIControlStateNormal];
    [addOptionBtn.titleLabel setFont:FONT(13)];
    [addOptionBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [addOptionBtn.titleLabel setNumberOfLines:1];
    [addOptionBtn setTitleColor:[Common colorFromHexRGB:@"2EC9CA"] forState:UIControlStateNormal];
    [addOptionBtn setImage:kImage(@"icon_add_options") forState:UIControlStateNormal];
    [addOptionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    addOptionBtn.tintColor = [UIColor whiteColor];
    [addOptionBtn addTarget:self action:@selector(addOptionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [addOptionView addSubview:addOptionBtn];
    [addOptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addOptionView);
        make.left.equalTo(addOptionView).offset(kDistanceToHSide+3);
    }];
    return addOptionView;
}

- (void)addOptionBtnAction {
    NSLog(@" addOption Click");
    if (self.optionIndex < STR_OPTION_MAX) {
        NSString *option = [NSString stringWithUTF8String:kOptionStr[self.optionIndex++]];
        AddImageView *customView0 = [AddImageView addImageViewWithType:AddImageViewVote AndOption:option];
        customView0.textView.userInteractionEnabled = NO;

        TTCommonItem *attachment0 = [TTCommonCustomViewItem itemWithCustomView:customView0];
        
        
        TTCommonGroup *group = [self.data objectAtIndex:1];
        NSMutableArray *items = group.items;
        [items insertObject:attachment0 atIndex:items.count-1];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:group.items.count - 2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:group.items.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
    else {
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"只能设置9个选项."];
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
    cell.lastRowInSection = (group.items.count - 1 == indexPath.row);
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WeakSelf;
    cell.actionBlock = ^ (NSString *text) {
        wself.text = text;
        TTCommonGroup *group = wself.data[0];
        TTCommonItem *textItem = group.items[1];
        [textItem setValue:text forKey:@"text"];
    };
    
    if (indexPath.section == 3) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f];
    }
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
    if (section == self.data.count - 1) {
        return 50;
    } else if (section == self.data.count - 2) {
        return 20;
    }
    return 10;
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
        _startMomentBtn.frame = CGRectMake(0, 0, Screen_Width - 10, 44);
        [_startMomentBtn setTitleColor:[Common colorFromHexRGB:@"2EC9CA"] forState:UIControlStateNormal];
        setViewCornerAndBorder(_startMomentBtn, 5);
        [_startMomentBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_startMomentBtn addTarget:self action:@selector(actionStartMoment) forControlEvents:UIControlEventTouchUpInside];
        _startMomentBtn.backgroundColor = kColorForBackgroud;
    }
    return _startMomentBtn;
}

//MARK:- 创建投票类型的Moment
- (void)actionStartMoment {
    if ([Common isEmptyArr:[CirclesManager sharedInstance].circles]) {
        [super showText:@"请先创建项目" afterSeconds:1.0];
        return;
    }
    
    if ([Common isEmptyString:_text]) {
        [super showText:@"请输入描述" afterSeconds:1.0];
        return;
    }
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 9 ; i++) {
        NSString *option = [NSString stringWithUTF8String:kOptionStr[i]];
        UIImage *image = [[[SelectPhotosManger sharedInstance] getPhotoesWithOption:option] firstObject];
        if (image == nil) continue;
        [imageArr addObject:image];
    }
    if ([Common isEmptyArr:imageArr]) {
        [super showText:@"请选择图片" afterSeconds:1.0];
        return;
    }
    if (imageArr.count <= 1) {
        [super showText:@"请选择至少两张图片" afterSeconds:1.0];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在上传图片并发布投票...";
    NSMutableArray *mediasArr = [NSMutableArray array];
    [QiniuUpoadManager uploadImages:imageArr progress:^(CGFloat progress) {
        hud.progress = progress;
    } success:^(NSArray *urls) {
        for (int i = 0; i < urls.count; i++) {
            NSDictionary *dic = @{@"vote_name":[NSString stringWithUTF8String:kOptionStr[i]],
                                  @"medias":@[@{@"type":@0,
                                                @"from":@2,
                                                @"url":urls[i]}]};
            [mediasArr addObject:dic];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:mediasArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *votesStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *pid = (NSString *)([[CirclesManager sharedInstance] selectCircle][@"_id"]);
        NSString *name = (NSString *)([[CirclesManager sharedInstance] selectCircle][@"name"]);
        OptionType optionType = [CirclesManager sharedInstance].optionType;
        NSDictionary *dic = @{@"votes":votesStr,
                              @"vote_type":@(optionType),//0--单选  1--多选
                              @"pid":pid,
                              @"vote_title":_text,
                              @"type":@2 //1为普通的moment  2为投票类型
                              };
        VoteCreateApi *voteCreatApi = [[VoteCreateApi alloc] init];
        voteCreatApi.requestArgument = dic;
        [voteCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [hud hideAnimated:YES];
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
            if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
                //添加统计事件
                NSString *label = optionType == OptionSingle ? @"单选" : @"多选";
                [Analyticsmanager eventWithEventId:event_id_voteOptionType withLabel:label withParameters:nil];
                if (self.addVoteBlock) {
                    self.addVoteBlock(pid, name);
                }
                //删除图片缓存
                [[SelectPhotosManger sharedInstance] cleanSelectAssets];
                [[SelectPhotosManger sharedInstance] cleanSelectPhotoes];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            NSLog(@"%@", error);
            if (error) {
                [hud hideAnimated:YES];
                [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
            }
        }];
    } failure:^(NSError *error) {
        if (error) {
            [hud hideAnimated:YES];
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }
    }];
}


@end
