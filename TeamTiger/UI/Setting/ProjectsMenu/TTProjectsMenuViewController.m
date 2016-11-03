//
//  TTProjectsMenuViewController.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTProjectsMenuViewController.h"
#import "IQKeyboardManager.h"
#import "MockDatas.h"
#import "GroupHeadView.h"
#import "ProjectsCell.h"
#import "ProjectsView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYAdd.h"
#import "TTMyProfileViewController.h"
#import "TTAddProjectViewController.h"
#import "GroupView.h"
#import "UIViewController+MMDrawerController.h"
#import "TTSettingViewController.h"

@interface TTProjectsMenuViewController ()

@property(nonatomic,strong)ProjectsView *pView;

@property(nonatomic,strong)GroupView *gView;

@end

@implementation TTProjectsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [Common removeExtraCellLines:self.menuTable];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
    self.menuTable.backgroundView = v;
    self.menuTable.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 1) {
        return self.unGroupedProjects.count;
    }
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section > 1) {
        static NSString *cellID = @"CellIdentifyProject";
        cell = (ProjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = LoadFromNib(@"ProjectsCell");
            cell.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tag = indexPath.section * 1000  + indexPath.row;
        NSDictionary *projectInfo = self.unGroupedProjects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.unGroupedProjects.count - 1];
        
        __weak typeof(cell) tempCell = cell;
        //设置删除cell回调block
        ((ProjectsCell *)cell).deleteMember = ^{
             [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目？" buttonTitles:@[@"确定",@"取消"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
             }];
        };
        //增加成员的cell回调block
        ((ProjectsCell *)cell).addMember = ^{
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要添加该项目至组？" buttonTitles:@[@"确定",@"取消"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
            }];
        };
        //设置当cell左滑时，关闭其他cell的左滑
        ((ProjectsCell *)cell).closeOtherCellSwipe = ^{
            for (ProjectsCell *item in tableView.visibleCells) {
                if ([item isKindOfClass:[ProjectsCell class]] && item != tempCell) {
                    [item closeLeftSwipe];
                }
            }
        };
    }
    else {
        static NSString *cellID = @"CellIdentify";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0) {
            [cell addSubview:self.infoView];
            [self loadUserInfo];
            [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left);
                make.right.mas_equalTo(cell.mas_right);
                make.top.mas_equalTo(cell.mas_top);
                make.bottom.mas_equalTo(cell.mas_bottom).offset(minLineWidth);
            }];
        } else {
            [cell addSubview:self.pView];
            [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell);
            }];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return minLineWidth;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return minLineWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    GroupHeadView *headView = LoadFromNib(@"GroupHeadView");
    if (section >= 1) {
        headView.isEnabledSwipe = NO;
        [headView loadHeadViewIndex:section];
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return CELLHEIGHT;
    } else if (indexPath.section == 0) {
        return 120.0;
    } else {
        return [ProjectsView heightOfProjectsView:self.groups];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)clickHeadInfoAction:(id)sender {
    TTMyProfileViewController *myProfileVC = [[TTMyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileVC animated:YES];
}

- (IBAction)clickHomeAction:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

#pragma -mark Data Handle
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray arrayWithArray:[MockDatas groups]];
    }
    return _groups;
}

- (NSMutableArray *)projects {
    if (!_projects) {
        _projects = [NSMutableArray arrayWithArray:[MockDatas projects]];
    }
    return _projects;
}

- (NSMutableArray *)unGroupedProjects {
    if (!_unGroupedProjects) {
        _unGroupedProjects = [NSMutableArray arrayWithArray:[MockDatas unGroupedProjects]];
    }
    return _unGroupedProjects;
}

- (NSDictionary *)projectsByPid:(NSString *)pid {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Id"] isEqualToString:pid];
    }];
    NSArray *results = [self.projects filteredArrayUsingPredicate:predicate];
    if (results && results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

- (void)addCirclesAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:[MockDatas projects]];
        [self.gView show];
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@",object);
            }
        };
    }
}

- (void)loadUserInfo {
    NSDictionary *dic = [MockDatas testerInfo];
    self.nameLab.text = dic[@"Name"];
    self.remarkLab.text = dic[@"Remarks"];
    if (![Common isEmptyString:dic[@"HeadImage"]]) {
        NSString *urlString = dic[@"HeadImage"];
        NSMutableString *mString = [NSMutableString string];
        if ([urlString containsString:@".jpg"] || [urlString containsString:@".png"]) {
            mString = urlString.mutableCopy;
        } else {
            NSArray *components = [urlString componentsSeparatedByString:@"/"];
            NSInteger count = components.count;
            [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != count - 1) {
                    [mString appendFormat:@"%@/",obj];
                } else {
                    [mString appendString:@"132"];//头像大小 46 64 96 132
                }
            }];
        }
        NSURL *url = [NSURL URLWithString:mString];
        [self.headImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"common-headDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            image = [image imageByRoundCornerRadius:66];
            self.headImgV.image = image;
        }];
    }
}

- (ProjectsView *)pView {
    if (!_pView) {
        _pView = [[ProjectsView alloc] initWithDatas:self.groups];
        //data handle
        _pView.projectBlock = ^(ProjectsView *tmpView, id object){
#warning TO DO HERE
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"跳转具体项目的列表" buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                
            }];
        };
        WeakSelf;
        _pView.addProjectBlock = ^(ProjectsView *tmpView){
            [wself addCirclesAction];
            
            // add project
//            TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
//            TTBaseNavigationController *baseNav = [[TTBaseNavigationController alloc] initWithRootViewController:addProfileVC];
//            [wself.navigationController presentViewController:baseNav animated:YES completion:nil];
        };
    }
    return _pView;
}

- (GroupView *)gView {
    if (!_gView) {
        _gView = LoadFromNib(@"GroupView");
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_gView];
        [_gView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(Screen_Height);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
    }
    return _gView;
}

@end
