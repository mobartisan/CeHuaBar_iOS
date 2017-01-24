//
//  TTSettingViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/27.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "Constant.h"
#import "IQKeyboardManager.h"
#import "SettingCell.h"
#import "TTAddProjectViewController.h"
#import "UIAlertView+HYBHelperKit.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "AFNetworking.h"
#import "CirclesManager.h"
#import "TTAddProjectFooterView.h"
#import "AddImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "UIImage+Extension.h"



@interface TTAddProjectViewController () <WXApiManagerDelegate, TZImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic) NSString *name;//项目名称
@property (strong, nonatomic) NSString *project_id;
@property (strong, nonatomic) NSMutableArray *membersArray;//搜索结果成员数组
@property (strong, nonatomic) NSMutableArray *selectMembers;//选择成员数组
@property (strong, nonatomic) UIImage *tempImage;//项目logo
@property (strong, nonatomic) UIImagePickerController *imagePickerVc;

@end

@implementation TTAddProjectViewController

#pragma -mark - getters
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithObjects:
                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"项目图标",@"TYPE":@"0"},
                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"项目名称",@"TYPE":@"1"},
                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"添加成员",@"TYPE":@"2"},
                  @{@"NAME":@"",@"TITLE":@"",@"TYPE":@"3"},nil];
    }
    return _datas;
}

- (NSMutableArray *)membersArray {
    if (_membersArray == nil) {
        _membersArray = [NSMutableArray array];
    }
    return _membersArray;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加项目";
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [Common removeExtraCellLines:self.contentTable];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;
    [self userRelation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datas[indexPath.section];
    
    static NSString *cellId = @"CellIdentify";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [SettingCell loadCellWithData:dic];
    }
    [cell reloadCell:dic];
    //项目图标
    if (self.tempImage == nil || [self.tempImage isEqual:[NSNull null]]) {
        cell.projectIcon.image = kImage(@"img_logo");
    } else {
        cell.projectIcon.image = self.tempImage;
    }
    //创建按钮
    if ([Common isEmptyString:self.name]) {
        cell.textField.text = nil;
        cell.textField.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.textField.text = self.name;
        cell.textField.textAlignment = NSTextAlignmentRight;
    }
    
    cell.actionBlock = ^(SettingCell *settingCell, ECellType type, id obj){
        switch (type) {
            case ECellTypeProjectIcon:{
                [self.view endEditing:YES];
                UIActionSheet *sheet = [UIActionSheet hyb_showInView:self.view title:nil cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"拍照",@"去相册选择"] callback:^(UIActionSheet *actionSheet, NSUInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self takePhoto];
                    } else if (buttonIndex == 1) {
                        [self pushImagePickerController];
                    }
                }];
                sheet.actionSheetStyle = UIActionSheetStyleDefault;
                break;
            }
            case ECellTypeProjectName:{
                self.name = obj;
                break;
            }
            case ECellTypeAddMember:{//添加人员
                [self.contentTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case ECellTypeBottom:{//创建按钮
                [self createProjectWithProjectName];
                break;
            }
            case ECellTypeProjectAdd:{
                
                break;
            }
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        int memberCount = (int)self.membersArray.count;
        if (memberCount > 8) {
            return 8 * kCellHeight + 1;
        }
        return memberCount * kCellHeight + 1;
        
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        self.selectMembers = [NSMutableArray array];
        TTAddProjectFooterView *footerView = [[TTAddProjectFooterView alloc] init];
        [footerView.dataSource addObjectsFromArray:self.membersArray];
        footerView.addMemberBlock = ^(NSMutableArray *members) {
            [self.view endEditing:YES];
            if (![Common isEmptyArr:self.selectMembers]) {
                [self.selectMembers removeAllObjects];
            }
            if (![Common isEmptyArr:members]) {
                [self.selectMembers addObjectsFromArray:members];
            }
        };
        return footerView;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
}

<<<<<<< HEAD
=======
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UIImage *)getNewImage:(UIImage *)image {
    CGFloat height = kScreenWidth * 767 / 1242;
    UIImage *normalImage = [image normalizedImage];
    // 获取当前使用的图片像素和点的比例
    CGFloat scale = [UIScreen mainScreen].scale;
    // 裁减图片
    CGImageRef imgR = CGImageCreateWithImageInRect(normalImage.CGImage, CGRectMake(0, 0, kScreenWidth * scale, height * scale));
    UIImage *resImage = [UIImage imageWithCGImage:imgR];
    CGImageRelease(imgR);
    return resImage;
}

>>>>>>> origin/master
#pragma mark - 创建项目
- (void)createProjectWithProjectName {
    if ([Common isEmptyString:self.name]) {
        [super showText:@"请输入项目名称" afterSeconds:1.0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.selectMembers options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if (self.tempImage == nil || [self.tempImage isEqual:[NSNull null]]) {
        [self projectCreate:@{@"name":self.name,
                              @"uids":memberStr}];//无logo
    } else {
        [QiniuUpoadManager uploadImage:[self getNewImage:self.tempImage] progress:nil success:^(NSString *url) {
            NSDictionary *dic = @{@"type":@0,
                                  @"from":@1,
                                  @"url":url};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *tempStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self projectCreate:@{@"name":self.name,
                                      @"logo":tempStr,
                                      @"uids":memberStr}];//有logo
            });
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }];
    }
    
}

- (void)projectCreate:(NSDictionary *)dic {
    ProjectCreateApi *projectCreateApi = [[ProjectCreateApi alloc] init];
    projectCreateApi.requestArgument = dic;
    [projectCreateApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectCreateApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
             [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectCreateApi:%@",error.description);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}


#pragma mark - 获取与当前用户存在项目关系的用户
- (void)userRelation{
    UserRelationApi *api = [[UserRelationApi alloc] init];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"UserRelationApi:%@", request.responseJSONObject);
        NSDictionary *response = request.responseJSONObject[OBJ];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:response[@"members"]]) {
                for (NSDictionary *membersDic in response[@"members"]) {
                    TT_User *user = [[TT_User alloc] init];
                    user.nick_name = membersDic[@"nick_name"];
                    user.head_img_url = membersDic[@"head_img_url"];
                    user.user_id = membersDic[@"uid"];
                    [self.membersArray addObject:user];
                }
                [self.membersArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    TT_User *tempUser1 = (TT_User *)obj1;
                    TT_User *tempUser2 = (TT_User *)obj2;
                    return [[tempUser1.nick_name pinyin] compare:[tempUser2.nick_name pinyin]];
                }];
            } else {
                [self.datas removeObjectAtIndex:2];
                [self.contentTable reloadData];
            }
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"UserRelationApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}


#pragma mark - 邀请成员到项目
- (void)addMemberToProject:(NSString *)project_id {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.selectMembers options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ProjectMemberInviteApi *api = [[ProjectMemberInviteApi alloc] init];
    api.requestArgument = @{@"pid":project_id,
                            @"uids":memberStr};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectMemberInviteApi:%@", request.responseJSONObject);
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectMemberInviteApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UIImage *)getNewImage:(UIImage *)image {
    CGFloat height = kScreenWidth * 767 / 1242;
    UIImage *normalImage = [image normalizedImage];
    // 获取当前使用的图片像素和点的比例
    CGFloat scale = [UIScreen mainScreen].scale;
    // 裁减图片
    CGImageRef imgR = CGImageCreateWithImageInRect(normalImage.CGImage, CGRectMake(0, 0, kScreenWidth * scale, height * scale));
    return [UIImage imageWithCGImage:imgR];
}

#pragma mark - 项目删除
- (void)projectDelete {
    ProjectDeleteApi *api = [[ProjectDeleteApi alloc] init];
    api.requestArgument = @{@"pid":self.project_id};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectDeleteApi:%@", request.responseJSONObject);
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectDeleteApi:%@", error);
    }];
}

#pragma mark - 选择项目logo
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self isNormal:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.tempImage = [self getNewImage:[photos firstObject]];
        [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            self.imagePickerVc.allowsEditing = YES;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.tempImage = [self getNewImage:image];
        [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 跳转微信加成员
- (void)handleAddMember {
    [self.view endEditing:YES];
    UIImage *thumbImage = [UIImage imageNamed:@"AppIcon"];
    //              方式一:
    //                NSData *data = [@"cehuabar" dataUsingEncoding:NSUTF8StringEncoding];
    //                [WXApiRequestHandler sendAppContentData:data
    //                                                ExtInfo:kAppContentExInfo //拼接参数
    //                                                 ExtURL:kAppContnetExURL //可以填app的下载地址
    //                                                  Title:kAPPContentTitle
    //                                            Description:kAPPContentDescription
    //                                             MessageExt:kAppMessageExt
    //                                          MessageAction:kAppMessageAction
    //                                             ThumbImage:thumbImage
    //                                                InScene:WXSceneSession];
    //              方式二:
    TT_User *user = [TT_User sharedInstance];
    NSString *nick_name = user.nickname;
    NSString *current_time = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
#warning to do here
    NSString *project_id = @"bsfbdfbdbfdbfdfdj";
    if(![Common isEmptyString:self.project_id]) {
        project_id = self.project_id;
    }
    NSString *project_name = @"待定项目";
    if (![Common isEmptyString:self.name]) {
        project_name = self.name;
    }
    NSString *subString = [Common encyptWithDictionary:@{@"project_id":project_id,
                                                         @"project_name":project_name,
                                                         @"nick_name":nick_name,
                                                         @"current_time":current_time} UnencyptKeys:@[@"project_name",@"nick_name",@"current_time"]];
    NSString *composeURL = [NSString stringWithFormat:@"%@?%@",kLinkURL, subString];
    composeURL = [composeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [WXApiRequestHandler sendLinkURL:composeURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:WXSceneSession];
}


#pragma -mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request {
    
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request {
    //微信回传消息
    [UIAlertView hyb_showWithTitle:@"提示" message:[request.message.mediaObject extInfo] buttonTitles:@[@"确定"] block:^(UIAlertView *alertView, NSUInteger buttonIndex) {}];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request {
    
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    //    返回应用时，收到消息回调
    NSLog(@"%@--%@", response.lang, response.country);
    [self.contentTable endEditing:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
}

@end
