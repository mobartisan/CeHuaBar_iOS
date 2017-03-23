//
//  TTAddContactorViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CacheManager.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "GDIIndexBar.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#import "TTAddContactorViewController.h"
#import "TTAddContactorViewController+AddressBook.h"
#import "UIColor+HYBHelperKitUIKit.h"

#define KBGColor    [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f]

@interface TTAddContactorViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,GDIIndexBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;//搜索框
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;//搜索VC
@property (nonatomic,strong) GDIIndexBar *indexBar;//index bar

@property (nonatomic,strong) NSArray *dataArr;//model化的数据源
@property (nonatomic,strong) NSArray *rowArr;//每一个section里面的数据
@property (nonatomic,strong) NSArray *sectionArr;//section数据
@property (nonatomic,strong) NSMutableArray *searchResultArr;//搜索结果Arr

@end

@implementation TTAddContactorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加成员";
    
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //contact table
    [Common removeExtraCellLines:self.contactTable];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = KBGColor;
    self.contactTable.backgroundView = bgView;
    self.contactTable.tableHeaderView = self.searchBar;
    
    //searchDisplayController
    [self searchDisplayController];
    
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSArray *tmpRowArray = [cacheManager getObjectForKey:Row_Data_Cache_Key];
    NSArray *tmpSectionArray = [cacheManager getObjectForKey:Section_Data_Cache_Key];
    if (tmpRowArray && tmpSectionArray) {
        self.rowArr = [NSArray arrayWithArray:tmpRowArray];
        self.sectionArr = [NSArray arrayWithArray:tmpSectionArray];
        [self.contactTable reloadData];
        [self indexBar];
    } else {
        //data source
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"正在加载...";
        hud.square = YES;
        
        [self dataArr];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.rowArr = [ContactModel getFriendListDataBy:self.dataArr.mutableCopy];
            self.sectionArr = [ContactModel getFriendListSectionBy:self.rowArr.mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.contactTable reloadData];
                [self indexBar];
                //save cache
                NSMutableArray *mArray = [NSMutableArray array];
                for (NSArray *array in self.rowArr) {
                    NSMutableArray *subMArray = [NSMutableArray array];
                    for (ContactModel *model in array) {
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [subMArray addObject:data];
                    }
                    [mArray addObject:subMArray];
                }
                [cacheManager setObject:mArray ForKey:Row_Data_Cache_Key TimeOut:gCacheTimeInterval];
                [cacheManager setObject:self.sectionArr ForKey:Section_Data_Cache_Key TimeOut:gCacheTimeInterval];
            });
        });
    }
}

#pragma -mark UITableView DataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.contactTable) {
        return self.rowArr.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contactTable) {
        return [self.rowArr[section] count];
    } else {
        return self.searchResultArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIde = @"cellIde";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    BOOL isLast = NO;
    if (tableView == self.contactTable) {
        if (indexPath.row == [self.rowArr[indexPath.section] count] - 1) {
            isLast = YES;
        }
        [cell reloadCell:self.rowArr[indexPath.section][indexPath.row]
                  IsLast:isLast];
    } else {
        if (indexPath.row == [self.searchResultArr count] - 1) {
            isLast = YES;
        }
        [cell reloadCell:self.searchResultArr[indexPath.row]
                  IsLast:isLast];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTable) {
        return 28.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [label setTextColor:[UIColor colorWithRed:49.0/255 green:55.0/255 blue:64.0/255 alpha:1]];
        [label setBackgroundColor:[UIColor colorWithRed:20.0/255.0 green:25.0/255.0 blue:36.0/255.0 alpha:1.0]];
    }
    [label setText:[NSString stringWithFormat:@"    %@",self.sectionArr[section + 1]]];
    return label;
}

#pragma marka - Index bar delegate
- (NSUInteger)numberOfIndexesForIndexBar:(GDIIndexBar *)indexBar {
    return self.sectionArr.count - 1;
}

- (NSString *)stringForIndex:(NSUInteger)index {
    if (index + 1 < self.sectionArr.count) {
        return self.sectionArr[index + 1];
    }
    return nil;
}

- (void)indexBar:(GDIIndexBar *)indexBar didSelectIndex:(NSUInteger)index {
    [self.contactTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}

#pragma -mark Getter 
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_searchBar sizeToFit];
        [_searchBar setPlaceholder:@"通过名称或电子邮箱搜索"];
        [_searchBar setDelegate:self];
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor whiteColor];
        
        UIImage *searchBarBg = [UIColor hyb_imageWithColor:[UIColor colorWithRed:31.0 / 255.0 green:33.0 / 255.0 blue:43.0 / 255.0 alpha:1.0] size:Size(1.0, 32.0)];
        [_searchBar setBackgroundImage:searchBarBg];
        [_searchBar setBackgroundColor:[UIColor colorWithRed:31.0 / 255.0 green:33.0 / 255.0 blue:43.0 / 255.0 alpha:1.0]];
        [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        searchField.tintColor = [UIColor whiteColor];
        [searchField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}

- (UISearchDisplayController *)searchDisplayController {
    if (!_searchDisplayController) {
        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        [_searchDisplayController setDelegate:self];
        [_searchDisplayController setSearchResultsDataSource:self];
        [_searchDisplayController setSearchResultsDelegate:self];
        [Common removeExtraCellLines:_searchDisplayController.searchResultsTableView];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = KBGColor;
        _searchDisplayController.searchResultsTableView.backgroundView = bgView;
        _searchDisplayController.searchResultsTableView.backgroundColor = KBGColor;
        _searchDisplayController.searchResultsTableView.rowHeight = 60;
        _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (!self.searchResultArr) {
            self.searchResultArr = [NSMutableArray array];
        }
    }
    return _searchDisplayController;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        [self loadDataFromSource:EDataFromAddressBook];
        _dataArr = [ContactModel modelArrayFromDictionaryArray:self.serverDataArr];
    }
    return _dataArr;
}

- (GDIIndexBar *)indexBar {
    if (!_indexBar) {
        _indexBar = [[GDIIndexBar alloc] initWithTableView:self.contactTable];
        _indexBar.delegate = self;
        _indexBar.textColor = [UIColor grayColor];
        _indexBar.textShadowColor = [UIColor colorWithWhite:0.f alpha:.5f];
        _indexBar.textShadowOffset = UIOffsetMake(1, 1);
        _indexBar.barBackgroundColor = KBGColor;
        _indexBar.textSpacing = 10.f;
        _indexBar.textFont = [UIFont fontWithName:@"Menlo-Bold" size:13.0f];
        [self.view addSubview:_indexBar];
    }
    return _indexBar;
}


#pragma mark searchBar delegate
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSArray *subViews;
    subViews = [(searchBar.subviews[0]) subviews];
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton *)view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark searchDisplayController delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [Common removeExtraCellLines:tableView];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[self.searchBar scopeButtonTitles][self.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:self.searchBar.text
                               scope:self.searchBar.scopeButtonTitles[searchOption]];
    return YES;
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    for (ContactModel *model in self.dataArr) {
        NSString *name = model.name;
        NSRange storeRange = NSMakeRange(0, name.length);
        NSRange foundRange = [name rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:[ContactModel customCopy:model]];
        }
    }
    [self.searchResultArr removeAllObjects];
    [self.searchResultArr addObjectsFromArray:tempResults];
}

@end
