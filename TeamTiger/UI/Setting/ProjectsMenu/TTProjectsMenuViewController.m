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
#import "ProjectItemView.h"

@interface TTProjectsMenuViewController ()

@property(nonatomic,strong)ProjectsView *pView;

@property(nonatomic,strong)GroupView *gView;

@property(nonatomic,strong)SelectGroupView *sgView;

@property (strong, nonatomic) NSString *unGroup_id;

@property (strong, nonatomic) NSMutableArray *allProjects;
@property (strong, nonatomic) NSMutableArray *touchPoints;

@property (assign, nonatomic) NSUInteger projectsCount;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *viewFrames;

@end

@implementation TTProjectsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllProjects];
    
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
    [self getAllGroups];
    
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
        return self.allProjects.count;
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
        TT_Project *projectInfo = self.allProjects[indexPath.row];
        [(ProjectsCell *)cell loadProjectsInfo:projectInfo IsLast:indexPath.row == self.allProjects.count - 1];
        
        //长按手势
        if (![Common isEmptyArr:self.groups]) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
            [(ProjectsCell *)cell addGestureRecognizer:longPress];
        }
        __weak typeof(cell) tempCell = cell;
        //设置删除cell回调block
        ((ProjectsCell *)cell).deleteMember = ^{
            [UIAlertView hyb_showWithTitle:@"提醒" message:@"您确定要删除该项目?" buttonTitles:@[@"取消", @"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSLog(@"删除项目");
                    [self.allProjects removeObject:projectInfo];
                    [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            
        };
        //置顶cell回调block
        ((ProjectsCell *)cell).addMember = ^{
            [self.allProjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != indexPath.row) {
                    ((TT_Project *)obj).isTop = NO;
                }
            }];
            TT_Project *tmpProject = projectInfo;
            [self.allProjects removeObject:projectInfo];
            if (tmpProject.isTop) {
                tmpProject.isTop = NO;
                [self.allProjects insertObject:tmpProject atIndex:self.index];
            }else {
                self.index = indexPath.row;
                tmpProject.isTop = YES;
                [self.allProjects insertObject:tmpProject atIndex:0];
            }
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        //免打扰
        ((ProjectsCell *)cell).noDisturbBlokc = ^{
            projectInfo.isNoDisturb = !projectInfo.isNoDisturb;
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
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
    }else if (section == 1) {
        return 30;
    }
    return 40;
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
        [headView loadHeadViewIndex:section projectCount:self.allProjects.count];
    }
    headView.addProjectBlock = ^() {
        TTAddProjectViewController *addProfileVC = [[TTAddProjectViewController alloc] initWithNibName:@"TTAddProjectViewController" bundle:nil];
        addProfileVC.requestData = ^() {
            [self.allProjects removeAllObjects];
            for (NSDictionary *objDic in [CirclesManager sharedInstance].circles) {
                TT_Project *tt_Project = [[TT_Project alloc] init];
                tt_Project.project_id = objDic[@"_id"];
                tt_Project.name = objDic[@"name"];
                [self.allProjects addObject:tt_Project];
                
            }
            [self.menuTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        
        TTBaseNavigationController *baseNav = [[TTBaseNavigationController alloc] initWithRootViewController:addProfileVC];
        [self.navigationController presentViewController:baseNav animated:YES completion:nil];
    };
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
            NSString *Id = [self.allProjects[indexPath.row] project_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"Title":[self.allProjects[indexPath.row] name], @"ISGROUP":@0}];
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

//获取所有的项目
- (void)getAllProjects {
    CirclesManager *circleManager = [CirclesManager sharedInstance];
    AllProjectsApi *allProject = [[AllProjectsApi alloc] init];
    [allProject startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getAllProjects:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:request.responseJSONObject[OBJ]]) {
                for (NSDictionary *objDic in request.responseJSONObject[OBJ]) {
                    [circleManager.circles addObject:objDic];
                    TT_Project *tt_Project = [[TT_Project alloc] init];
                    tt_Project.project_id = objDic[@"_id"];
                    tt_Project.name = objDic[@"name"];
                    [self.allProjects addObject:tt_Project];
                    
                }
                circleManager.selectIndex = 0;
                circleManager.selectCircle = (circleManager.circles)[circleManager.selectIndex];
            }
            self.projectsCount = circleManager.circles.count;
            [self.menuTable reloadData];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = @"您的网络好像有问题~";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma mark 获取所有分组
- (void)getAllGroups {
    AllGroupsApi *groupsApi = [[AllGroupsApi alloc] init];
    [groupsApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"getAllGroups:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            NSDictionary *objDic =  request.responseJSONObject[OBJ];
            //分组数据
            if (![Common isEmptyArr:self.groups]) {
                [self.groups removeAllObjects];
            }
            NSArray *groupArr = objDic[@"groups"];
            for (int i = 2; i < groupArr.count; i++) {
                TT_Group *group = [[TT_Group alloc] init];
                group.group_id = groupArr[i][@"_id"];
                group.group_name = groupArr[i][@"group_name"];
                [self.groups addObject:group];
            }
            self.unGroup_id = [objDic[@"projects"] firstObject][@"_id"];
            [self.menuTable reloadData];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"getAllGroups:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.5];
    }];
}

#pragma -mark Data Handle
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}



- (NSMutableArray *)touchPoints {
    if (_touchPoints == nil) {
        _touchPoints = [NSMutableArray array];
    }
    return _touchPoints;
}

- (NSMutableArray *)allProjects {
    if (_allProjects == nil) {
        _allProjects = [NSMutableArray array];
    }
    return _allProjects;
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertId" object:Id userInfo:@{@"Title":[object group_name], @"IsGroup":@1}];
                }
            }];
        };
        //添加分组
        _pView.addProjectBlock = ^(ProjectsView *tmpView){
            [wself creatGroupAction];
        };
        /*
         _pView.longPressBlock = ^(ProjectsView *tmpView, id object) {
         TTGroupViewController *groupVC = [[TTGroupViewController alloc] init];
         groupVC.allGroups = wself.groups;
         groupVC.groupId = [object group_id];
         groupVC.gid = [object group_id];
         [wself.navigationController pushViewController:groupVC animated:YES];
         };
         */
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

#pragma mark 创建分组
- (void)creatGroupAction {
    if (self.gView.isShow) {
        [self.gView hide];
    } else {
        [self.gView loadGroupInfo:nil AllProjects:self.allProjects];
        [self.gView show];
        WeakSelf;
        self.gView.clickBtnBlock = ^(GroupView *gView, BOOL isConfirm, id object){
            if (isConfirm) {
                NSLog(@"%@, %@",object[@"Name"], object[@"Pids"]);
                NSArray *pids = [object[@"Pids"] componentsSeparatedByString:@","];
                NSData *data = [NSJSONSerialization dataWithJSONObject:pids options:NSJSONWritingPrettyPrinted error:nil];
                NSString *strPids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                GroupCreatApi *groupCreatApi = [[GroupCreatApi alloc] init];
                groupCreatApi.requestArgument = @{@"group_name":object[@"Name"],
                                                  @"pids":strPids};
                [groupCreatApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    NSLog(@"creatGroupAction:%@", request.responseJSONObject);
                    [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
                    if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
                        [wself getAllGroups];
                    }
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    NSLog(@"%@", error);
                    [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
                }];
            }
        };
    }
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
#pragma mark  移动未分组项目移动到某个分组
- (void)addProjectIntoGroupAction:(TT_Project *)projectInfo {
    if (self.sgView.isShow) {
        [self.sgView hide];
    } else {
        [self.sgView loadGroups:self.groups];
        [self.sgView show];
        WeakSelf;
        self.sgView.clickBtnBlock = ^(SelectGroupView *sgView, BOOL isConfirm, id object){
            if (isConfirm) {
                [wself moveProjectFrom_gid:wself.unGroup_id to_group:object pid:projectInfo];
            }
        };
    }
}

- (void)moveProjectFrom_gid:(NSString *)from_gid to_group:(TT_Group *)group pid:(TT_Project *)pid {
    MoveProjectApi *moveProjectApi = [[MoveProjectApi alloc] init];
    moveProjectApi.requestArgument = @{@"from_gid":self.unGroup_id,
                                       @"to_gid":group.group_id,
                                       @"pid":[pid project_id]};//pid 项目id
    [moveProjectApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"moveProject:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [super showText:[NSString stringWithFormat:@"项目已添加至%@分组", group.group_name] afterSeconds:2.0];
        }else {
            [super showText:@"项目添加至该分组失败" afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"moveProject:%@", error);
        if (error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }
    }];
}

- (void)getViewFrames {
    self.viewFrames = [NSMutableArray array];
    int count = (int)[CirclesManager sharedInstance].views.count;
    for (int i = 0; i < count; i++) {
        UIView *tmpView = [CirclesManager sharedInstance].views[i];
        CGRect viewF =  [self.menuTable convertRect:tmpView.frame fromView:tmpView.superview];
        [self.viewFrames addObject:[NSValue valueWithCGRect:viewF]];
    }
}

#pragma mark 长按手势方法
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    [self getViewFrames];
    
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.menuTable];
    NSIndexPath *indexPath = [self.menuTable indexPathForRowAtPoint:location];
    TT_Project *project = [self.allProjects objectAtIndex:indexPath.row];
    static UIView *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.menuTable cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.menuTable addSubview:snapshot];
                // 按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    snapshot.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // 清空数组，非常重要，不然会发生坐标突变！
            [self.touchPoints removeAllObjects];
            UITableViewCell *cell = [self.menuTable cellForRowAtIndexPath:sourceIndexPath];
            
            for (NSValue *frameValue in self.viewFrames) {
                BOOL isContain =  CGRectContainsPoint([frameValue CGRectValue], location);
                if (isContain) {
                    
                    //1.取出下标
                    NSUInteger index =  [self.viewFrames indexOfObject:frameValue];
                    
                    // 将快照放到分组里面
                    [UIView animateWithDuration:0.25 animations:^{
                        snapshot.transform = CGAffineTransformMakeScale(0.3, 1.4);
                        //                        snapshot.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        [snapshot removeFromSuperview];
                        snapshot = nil;
                    }];
                    
                    //2.取出对应的模型
                    TT_Group *group = self.groups[index];
                    //3.刷新UI
                    [self.allProjects removeObject:project];
                    [self.menuTable reloadData];
                    //4.移动分组
                    [self moveProjectFrom_gid:self.unGroup_id to_group:group pid:project];
                }else {
                    cell.hidden = NO;
                    // 将快照恢复到初始状态
                    [UIView animateWithDuration:0.25 animations:^{
                        snapshot.center = cell.center;
                        snapshot.transform = CGAffineTransformIdentity;
                        snapshot.alpha = 0.0;
                        cell.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        [snapshot removeFromSuperview];
                        snapshot = nil;
                        
                    }];
                }
            }
            break;
        }
        default: {
            
            break;
        }
    }
    
}

#pragma mark 创建cell的快照
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}



@end
