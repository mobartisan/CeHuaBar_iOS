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
#import "UIImageView+WebCache.h"
#import "UIImage+YYAdd.h"

@interface TTProjectsMenuViewController ()

@end

@implementation TTProjectsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的项目";
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [Common customPopAnimationFromNavigation:wself.navigationController Type:kCATransitionPush SubType:kCATransitionFromRight];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCirclesAction)];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [Common removeExtraCellLines:self.menuTable];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f];
    self.menuTable.backgroundView = v;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 1) {
        return [[self.groups[section - 2][@"Pids"] componentsSeparatedByString:@","] count];
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
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:30.0/255.0f blue:41.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tag = indexPath.section * 1000  + indexPath.row;
        NSArray *pids = [self.groups[indexPath.section - 2][@"Pids"] componentsSeparatedByString:@","];
        NSDictionary *projectInfo = [self projectsByPid:pids[indexPath.row]];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == pids.count - 1];
    }
    else if(indexPath.section == 0) {
        static NSString *cellID = @"CellIdentify";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:30.0/255.0f blue:41.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:self.infoView];
        [self loadUserInfo];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell);
        }];
    }

    else {
        static NSString *cellID = @"CellIdentify";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:30.0/255.0f blue:41.0/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return minLineWidth;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return minLineWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    static NSString *headViewID = @"HeadViewID";
    GroupHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewID];
    if (!headView) {
        headView = LoadFromNib(@"GroupHeadView");
    }
    if (section > 1) {
        [headView loadHeadViewData:self.groups[section - 2]];
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return 53.0;
    } else if (indexPath.section == 0) {
        return 80.0;
    } else {
        //to do
        return 80.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*此处处理自己的代码，如删除数据*/
        //TO DO HERE
        /*删除tableView中的一行*/
//        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma -mark Data Handle
- (void)getTableDatas {
    
}

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
    [UIAlertView hyb_showWithTitle:@"提醒" message:@"增加分组" buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
        if (buttonIndex == 1) {
            
        }
    }];
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

@end
