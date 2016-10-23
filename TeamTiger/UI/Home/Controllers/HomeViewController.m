//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "YZInputView.h"
#import "IQKeyboardManager.h"
#import "ButtonIndexPath.h"
#import "HeadView.h"
#import "HomeCell.h"
#import "VoteHomeCell.h"
#import "HomeDetailCell5.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "TTSettingViewController.h"
#import "TTAddDiscussViewController.h"
#import "DiscussViewController.h"
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "TTAddVoteViewController.h"
#import "TTProjectsMenuViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, HeadViewDelegate, HomeCellDelegate, VoteHomeCellDelegate, UITextViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  评论视图
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet YZInputView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;
@property (strong, nonatomic) DataManager *manager;
@property (assign, nonatomic) BOOL isShowHeaderView;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation HomeViewController

- (DataManager *)manager {
    if (_manager == nil) {
        _manager = [DataManager mainSingleton];
    }
    return _manager;
}

- (void)reloadWithData:(id)data {
    self.title = data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowHeaderView = YES;
    self.title = @"Moments";
    keyBoardBGView = _bgView;
    // 监听文本框文字高度改变
    _textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        _bgViewHeightConstraint.constant = textHeight + 10;
    };
    _textView.keyboardAppearance = UIKeyboardAppearanceLight;
    // 设置文本框最大行数
    _textView.maxNumberOfLines = 4;
    _textView.placeholder = @"添加一条讨论";
    _textView.placeholderColor = [UIColor grayColor];
    
    [self configureNavigationItem];
    [self handleRefreshAction];
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoteHomeCell" bundle:nil] forCellReuseIdentifier:@"VoteHomeCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    [self getProject];
}

#pragma mark  查询项目列表
- (void)getProject {
    ProjectsApi *pro = [[ProjectsApi alloc] init];
    [pro startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSLog(@"ProjectsApi == %@", request.responseJSONObject);
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [super showHudWithText:@"您的网络好像有问题~"];
        [self hideHudAfterSeconds:3.0];
    }];

}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    [_bgView endEditing:YES];
}

#pragma mark -- 键盘上的视图显示和隐藏
- (void)keyBoardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _bgViewBottomConstraint.constant = keyBoardFrame.origin.y != kScreenHeight ? keyBoardFrame.size.height : -100;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)handleRefreshAction {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self addDataToDataArr];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer = footer;
    
}

- (void)addDataToDataArr {
    if (self.manager.dataSource.count > 3) {
        return;
    }
    NSDictionary *dic = @{@"projectType":@(ProjectTypeAll),
                          @"imageCount":@(2),
                          @"time":@"7月19日 9:27",
                          @"headImage":@"touxiang",
                          @"name":@"齐云猛",
                          @"type":@"易会",
                          @"image1":@"image",
                          @"image2":@"image",
                          @"image3":@"image",
                          @"comment":@[
                                  @{@"time":@"20:51",
                                    @"firstName":@"曹兴星",
                                    @"secondName":@"@卞克",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton)
                                    },
                                  @{@"time":@"13:55",
                                    @"firstName":@"卞克",
                                    @"secondName":@"@唐小旭",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton)
                                    },
                                  @{@"time":@"9:00",
                                    @"firstName":@"齐云猛",
                                    @"secondName":@"",
                                    @"des":@"TypeSomething...",
                                    @"secondImage":@"image",
                                    @"firstImage":@"image",
                                    @"typeCell":@(TypeCellTitle)
                                    },
                                  @{@"time":@"昨天",
                                    @"firstName":@"2016年7月18日",
                                    @"secondName":@"@唐小旭",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTime)
                                    },
                                  @{@"time":@"13:55",
                                    @"firstName":@"俞弦",
                                    @"secondName":@"",
                                    @"des":@"TypeSomething...",
                                    @"firstImage":@"image",
                                    @"secondImage":@"image",
                                    @"typeCell":@(TypeCellTitleNoButton),
                                    },
                                  ].mutableCopy
                          };
    [self.manager.dataArr addObject:dic];
    HomeCellModel *model = [HomeCellModel modelWithDic:dic];
    [self.manager.dataSource addObject:model];
    
}

- (void)configureNavigationItem {
    //左侧
    UIToolbar *tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 80, 39)];
    tools.clipsToBounds = YES;
    [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
    [tools setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    //添加两个button
    NSMutableArray *buttons = [NSMutableArray array];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:-16];
    [buttons addObject:spaceButtonItem];

    UIBarButtonItem *projectsBtn =[[UIBarButtonItem alloc] initWithImage:kImage(@"icon_list") style: UIBarButtonItemStyleDone target:self action:@selector(projectsBtnAction)];
    projectsBtn.tintColor = [UIColor whiteColor];
    [buttons addObject:projectsBtn];

    UIBarButtonItem *spaceButtonItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem2 setWidth:16];
    [buttons addObject:spaceButtonItem2];
    
    UIBarButtonItem *settingBtn =[[UIBarButtonItem alloc]initWithImage:kImage(@"icon_install") style: UIBarButtonItemStyleDone target:self action:@selector(settingBtnAction)];
    settingBtn.tintColor = [UIColor whiteColor];
    [buttons addObject:settingBtn];
    
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:tools];
    self.navigationItem.leftBarButtonItem = btn;
    
    //右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:kImage(@"icon_add") forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [rightBtn addTarget:self action:@selector(handleRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)projectsBtnAction {
    //项目列表
    TTProjectsMenuViewController *projectsMenuVC = [[TTProjectsMenuViewController alloc] initWithNibName:@"TTProjectsMenuViewController" bundle:nil];
    [Common customPushAnimationFromNavigation:self.navigationController ToViewController:projectsMenuVC Type:kCATransitionPush SubType:kCATransitionFromLeft];
}

- (void)settingBtnAction {
    TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
    [Common customPushAnimationFromNavigation:self.navigationController ToViewController:settingVC Type:kCATransitionPush SubType:kCATransitionFromLeft];
}

- (void)handleRightBtnAction {
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMPopupItemHandler block = ^(NSInteger index){
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        HomeCell *cell = [HomeCell homeCellWithTableView:tableView model:model];
        cell.model = model;
        cell.delegate = self;
        cell.moreBtn.indexPath = indexPath;
        //展开按钮
        [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        //评论
        cell.clickCommentBtn = ^(UIButton *btn) {
            self.indexPath = indexPath;
            [self.textView becomeFirstResponder];
        };
        [cell.tableView reloadData];
        return cell;
    }else {
        VoteHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteHomeCell"];
        cell.model = model;
        cell.delegate = self;
        cell.moreBtn.indexPath = indexPath;
        [cell.moreBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        //评论
        cell.clickBtn = ^(UIButton *btn) {
            self.indexPath = indexPath;
            [self.textView becomeFirstResponder];
        };
        //投票
        [cell setVoteClick:^() {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [cell.tableView reloadData];
        return cell;
    }
}

- (void)handleClickAction:(ButtonIndexPath *)button {
    HomeCellModel *model = self.manager.dataSource[button.indexPath.row];
    model.isClick = !model.isClick;
    if (!model.isClick) {
        model.height = 0.0;
    }
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *model = self.manager.dataSource[indexPath.row];
    if (model.projectType == ProjectTypeAll) {
        return [HomeCell cellHeightWithModel:model];
    }else {
        return [VoteHomeCell cellHeightWithModel:model];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isShowHeaderView) {
        HeadView *headerView = [HeadView headerViewWithTableView:tableView];
        headerView.delegate = self;
        return headerView;
    }else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isShowHeaderView) {
        return 60;
    }else {
        return 0;
    }
}

#pragma mark HomeCellDelegate
- (void)reloadHomeTableView:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}

#pragma mark VoteHomeCellDelegate
- (void)reloadTableViewWithHeight:(CGFloat)height withIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    
}

#pragma mark HeadViewDelegate
- (void)headViewDidClickWithHeadView:(HeadView *)headView {
    DiscussViewController *discussVC = [[DiscussViewController alloc] init];
    [self.navigationController pushViewController:discussVC animated:YES];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
#warning TO DO 
        NSString *project_id = @"5b0406e0-70de-11e6-b11e-57f534258fb6";
        DiscussCreateApi *discussCreatApi = [[DiscussCreateApi alloc] init];
        discussCreatApi.requestArgument = @{@"project_id":project_id};
        [discussCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
                NSLog(@"%@", request.responseJSONObject);
                [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                //创建讨论失败
                [super showHudWithText:request.responseJSONObject[MSG]];
                [super hideHudAfterSeconds:3.0];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            NSLog(@"%@",error.description);
            [self showHudWithText:@"您的网络好像有问题~"];
            [self hideHudAfterSeconds:3.0];
        }];
        
      
        
//        HomeDetailCellModel *detailModel = [HomeDetailCellModel modelWithDic:dic];
//        [model.comment insertObject:detailModel atIndex:0];
//        model.isClick = YES;
//        model.height = 0.0;
//        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_bgView endEditing:YES];
        return NO;
    }
    return YES;
}


@end
