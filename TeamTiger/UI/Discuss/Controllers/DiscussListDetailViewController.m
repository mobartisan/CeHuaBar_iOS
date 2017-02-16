//
//  DiscussListDetailViewController.m
//  TeamTiger
//
//  Created by Dale on 17/2/9.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "DiscussListDetailViewController.h"
#import "HomeCell.h"
#import "HomeVoteCell.h"
#import "HomeModel.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "IQKeyboardManager.h"

@interface DiscussListDetailViewController () <UIScrollViewDelegate, HomeCellDelegate, HomeVoteCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation DiscussListDetailViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItem];
    [self getMomentDetail];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [Common removeExtraCellLines:self.tableView];
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

- (void)handleKeyBoard:(NSNotification *)notification {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    HomeModel *homdModel = self.dataSource[indexPath.row];
    CGFloat height = homdModel.indexModel.homeCommentModel.open ? homdModel.totalHeight : homdModel.partHeight;
    CGRect keyBoradFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HomeCell *cell = (HomeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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

//FIXME: - 根据mid得到具体的moment
- (void)getMomentDetail {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MomentDetailApi *api = [[MomentDetailApi alloc] init];
    api.requestArgument = @{@"mid":self.mid};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"MomentDetailApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic = request.responseJSONObject[OBJ];
            if (kIsDictionary(objDic)) {
                HomeModel *homeModel = [HomeModel modelWithDic:objDic];
                homeModel.open = YES;
                [self.dataSource addObject:homeModel];
            }
            self.title = ((HomeModel *)[self.dataSource firstObject]).name;
        } else {
            [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"MomentDetailApi:%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:NETWORKERROR afterSeconds:1.0];
    }];
}

- (void)configureNavigationItem {
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
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
        ((HomeCell *)cell).homeModel = model;
        ((HomeCell *)cell).delegate = self;
    } else {
        cell = (HomeVoteCell *)[HomeVoteCell cellWithTableView:tableView];
        ((HomeVoteCell *)cell).homeModel = model;
        ((HomeVoteCell *)cell).projectBtn.indexPath = indexPath;
        ((HomeVoteCell *)cell).delegate = self;
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


#pragma mark - HomeCellDelegate
- (void)clickCommentBtn:(NSIndexPath *)indexPath {
    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)currentIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - HomeVoteCellDeleagte
- (void)clickVoteBtn:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickVoteSuccess:(NSIndexPath *)indexPath homeModel:(HomeModel *)model {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.dataSource insertObject:model atIndex:indexPath.row];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
