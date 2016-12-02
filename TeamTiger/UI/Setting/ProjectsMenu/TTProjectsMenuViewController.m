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
#import "SelectGroupView.h"
#import "UIViewController+MMDrawerController.h"
#import "TTSettingViewController.h"
#import "TTGroupViewController.h"
#import "NSString+YYAdd.h"

@interface TTProjectsMenuViewController ()

@property(nonatomic,strong)ProjectsView *pView;

@property(nonatomic,strong)GroupView *gView;

@property(nonatomic,strong)SelectGroupView *sgView;

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
    [super viewDidDisappear:animated];
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
        }
        cell.tag = indexPath.section * 1000  + indexPath.row;
        NSDictionary *projectInfo = self.unGroupedProjects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.unGroupedProjects.count - 1];
        
        __weak typeof(cell) tempCell = cell;
        //设置删除cell回调block
        ((ProjectsCell *)cell).deleteMember = ^{
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"未分组的项目无法移出分组" buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {}];
        };
        //增加项目至分组的cell回调block
        ((ProjectsCell *)cell).addMember = ^{
            [self addProjectIntoGroupAction:projectInfo];
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
            [self.pView loadGroupsInfos:self.groups];
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
        return [ProjectsView heightOfProjectsView:self.groups] + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ProjectsCell class]]) {
        ((ProjectsCell *)cell).backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        ((ProjectsCell *)cell).containerView.backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        [UIView animateWithDuration:0.3 animations:^{
            ((ProjectsCell *)cell).backgroundColor = [UIColor clearColor];
            ((ProjectsCell *)cell).containerView.backgroundColor = [UIColor clearColor];
        }];
    }
    //主页moments
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        if (finished) {
            NSString *Id = [self.unGroupedProjects[indexPath.row] project_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"Title":[self.unGroupedProjects[indexPath.row] name], @"ISGROUP":@0}];
        }
    }];
}

- (IBAction)clickHeadInfoAction:(id)sender {
    TTMyProfileViewController *myProfileVC = [[TTMyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileVC animated:YES];
}

- (IBAction)clickHomeAction:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:@"" userInfo:@{@"Title":@"Moments", @"ISGROUP":@0}];
    }];
}

#pragma -mark Data Handle
- (NSMutableArray *)groups {
    if (!_groups) {
        TT_User *user = [TT_User sharedInstance];
        [SQLITEMANAGER setDataBasePath:user.user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by create_date",TABLE_TT_Group];
        NSArray *groups = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Group];
        _groups = [NSMutableArray arrayWithArray:groups];
    }
    return _groups;
}

- (NSMutableArray *)projects {
    if (!_projects) {
        [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by create_date",TABLE_TT_Project];
        NSArray *projects = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Project];
        _projects = [NSMutableArray arrayWithArray:projects];
    }
    return _projects;
}

- (NSMutableArray *)unGroupedProjects {
    if (!_unGroupedProjects) {
        [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where is_grouped = 0 order by create_date",TABLE_TT_Project];
        NSArray *ungroupedProjects = [SQLITEMANAGER selectDatasSql:sqlString Class:TABLE_TT_Project];
        _unGroupedProjects = [NSMutableArray arrayWithArray:ungroupedProjects];
    }
    return _unGroupedProjects;
}

- (void)creatGroupAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:self.projects];
        [self.gView show];
        WeakSelf;
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@",object);
                TT_User *user = [TT_User sharedInstance];
                [SQLITEMANAGER setDataBasePath:user.user_id];
                NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO %@(group_id, name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('%@','%@','%@',null,0,0,datetime('now','localtime'),'%@',datetime('now','localtime'),'%@')",TABLE_TT_Group, object[@"Gid"], object[@"Name"], object[@"Pids"] ,user.user_id, user.user_id];
                [SQLITEMANAGER executeSql:sqlString];
                [wself.groups addObject:[TT_Group creatGroupWithDictionary:object]];
                [wself.menuTable reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                    hud.label.text = @"创建分组成功";
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:1.5];
                });
            }
        };
    }
}

- (void)addProjectIntoGroupAction:(id)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:self.groups];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@",object);
                NSMutableArray *pids = [[object pids] componentsSeparatedByString:@","].mutableCopy;
                if([pids containsObject:[projectInfo project_id]]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                        hud.label.text = @"项目已存在该分组";
                        hud.mode = MBProgressHUDModeText;
                        [hud hideAnimated:YES afterDelay:1.5];
                    });
                } else {
                    //添加至分组
                    [pids addObject:[projectInfo project_id]];
                    NSString *nwPids = [pids componentsJoinedByString:@","];
                    NSString *updateSql = [NSString stringWithFormat:@"update %@ set pids = '%@'",TABLE_TT_Group, nwPids];
                    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
                    [SQLITEMANAGER executeSql:updateSql];
                    //更改项目状态
                    updateSql = [NSString stringWithFormat:@"update %@ set is_grouped = 1",TABLE_TT_Project];
                    [SQLITEMANAGER executeSql:updateSql];
                    //刷新UI
                    [wself.unGroupedProjects removeObject:projectInfo];
                    [wself.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
                    //给出提示
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
                        hud.label.text = @"项目已添加至该分组";
                        hud.mode = MBProgressHUDModeText;
                        [hud hideAnimated:YES afterDelay:1.5];
                    });
                }
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
        _pView = [[ProjectsView alloc] initWithDatas:[NSArray array]];
        
        WeakSelf;
        //data handle
        _pView.projectBlock = ^(ProjectsView *tmpView, id object){
            [wself.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                if (finished) {
                    NSString *Id = [object group_id];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"ISGROUP":@1, @"Title":[object name]}];
                }
            }];
        };
        _pView.addProjectBlock = ^(ProjectsView *tmpView){
            [wself creatGroupAction];
        };
        _pView.longPressBlock = ^(ProjectsView *tmpView, id object) {
            TTGroupViewController *groupVC = [[TTGroupViewController alloc] init];
            groupVC.groupId = [object group_id];
            [wself.navigationController pushViewController:groupVC animated:YES];
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

- (SelectGroupView *)sgView {
    if (!_sgView) {
        _sgView = LoadFromNib(@"SelectGroupView");
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_sgView];
        [_sgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(Screen_Height);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
    }
    return _sgView;
}

@end
