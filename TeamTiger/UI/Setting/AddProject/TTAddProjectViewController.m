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
@property (copy, nonatomic) NSString *tempName;
@property (strong, nonatomic) NSString *project_id;
@property (strong, nonatomic) NSString *msgString;
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
        if (![Common isEmptyString:self.project_id]) {
            [self projectDelete];
        }
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [Common removeExtraCellLines:self.contentTable];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [WXApiManager sharedManager].delegate = self;
    
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
                    if (buttonIndex == 0) { // take photo / 去拍照
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
            case ECellTypeAddMember:{
                [self userRelation];
                break;
            }
            case ECellTypeBottom:{
                [self projectUpdate];
                break;
            }
            case ECellTypeProjectAdd:{
                [self createProjectWithProjectName:self.name];
                break;
            }
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 3) {
    //        return 80;
    //    }
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
        return memberCount * kCellHeight + 1;
        
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.selectMembers = [NSMutableArray array];
    if (section == 2) {
        TTAddProjectFooterView *footerView = [[TTAddProjectFooterView alloc] init];
        [footerView.dataSource addObjectsFromArray:self.membersArray];
        footerView.addMemberBlock = ^(NSMutableArray *members) {
            if (![Common isEmptyArr:members]) {
                [self.selectMembers addObjectsFromArray:members];
            }
        };
        footerView.toWeChat = ^(){
            [self handleAddMember];
        };
        return footerView;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
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

#pragma mark - 创建项目
- (void)createProjectWithProjectName:(NSString *)name {
    if (![self.tempName isEqualToString:name] && ![Common isEmptyString:self.tempName]) {
        return;
    }
    
    if (self.tempImage == nil || [self.tempImage isEqual:[NSNull null]]) {
        [self projectCreat:name tempDic:[NSDictionary dictionary]];//无logo
    } else {
        [QiniuUpoadManager uploadImage:[self getNewImage:self.tempImage] progress:nil success:^(NSString *url) {
            NSDictionary *dic = @{@"type":@0,
                                  @"from":@1,
                                  @"url":url};
            dispatch_async(dispatch_get_main_queue(), ^{
                [self projectCreat:name tempDic:dic];//有logo
            });
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }];
    }
    
}

- (void)projectCreat:(NSString *)projectName tempDic:(NSDictionary *)dic{
    ProjectCreateApi *projectCreateApi = [[ProjectCreateApi alloc] init];
    projectCreateApi.requestArgument = @{@"logo":dic,
                                         @"name":projectName
                                         };
    [projectCreateApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectCreateApi:%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            self.project_id = request.responseJSONObject[OBJ][@"pid"];
            self.tempName = projectName;
            [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
        } else {
            self.msgString = request.responseJSONObject[MSG];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectCreateApi:%@",error.description);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 模糊搜索
- (void)userSearch:(NSString *)key {
    if ([Common isEmptyString:key]) {
        [super showText:@"请输入搜索关键字" afterSeconds:1.0];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserSearchApi *api = [[UserSearchApi alloc] init];
    api.requestArgument = @{@"key":key};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *response = request.responseJSONObject;
        if (response[OBJ] != nil && ![response[OBJ] isEqual:[NSNull null]]) {
            TT_User *user = [[TT_User alloc] init];
            user.nick_name = response[OBJ][@"nick_name"];
            user.head_img_url = response[OBJ][@"head_img_url"];
            user.user_id = response[OBJ][@"uid"];
            [self.membersArray addObject:user];
            
            
            TT_User *tempUser = [[TT_User alloc] init];
            tempUser.nick_name = [NSString stringWithFormat:@"搜索更多相关“%@”的微信用户", key];
            tempUser.city = @"搜索更多相关“";
            tempUser.country = key;
            [self.membersArray addObject:tempUser];
        } else {
            TT_User *tempUser = [[TT_User alloc] init];
            tempUser.nick_name = [NSString stringWithFormat:@"无该用户信息,搜索“%@”相关微信用户", key];
            tempUser.city = @"无该用户信息,搜索“";
            tempUser.country = key;
            [self.membersArray addObject:tempUser];
        }
        
        [self.contentTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 获取与当前用户存在项目关系的用户
- (void)userRelation {
    self.membersArray = [NSMutableArray array];
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
            }
            TT_User *tempUser = [[TT_User alloc] init];
            tempUser.nick_name = @"选择更多相关的微信用户";
            [self.membersArray addObject:tempUser];
            
        } else {
            TT_User *tempUser = [[TT_User alloc] init];
            tempUser.nick_name = @"选择更多相关的微信用户";
            [self.membersArray addObject:tempUser];
        }
        [self.contentTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"UserRelationApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 邀请成员到项目
- (void)addMemberToProject {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.selectMembers options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ProjectMemberInviteApi *api = [[ProjectMemberInviteApi alloc] init];
    api.requestArgument = @{@"pid":self.project_id,
                            @"uids":memberStr};
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectMemberInviteApi:%@", request.responseJSONObject);
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectMemberInviteApi:%@", error);
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 修改项目信息
- (void)projectUpdate {
    if ([Common isEmptyString:self.name]) {
        [super showText:@"请输入项目名称" afterSeconds:1.0];
        return;
    }
    if (![Common isEmptyString:self.msgString]) {
        [super showText:self.msgString afterSeconds:1.0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"self.project_id:%@", self.project_id);
    if (self.tempImage == nil || [self.tempImage isEqual:[NSNull null]]) {
        [self projectUpdate:@{@"pid":self.project_id,
                              @"name":self.name}];//无logo
    } else {
        [QiniuUpoadManager uploadImage:[self getNewImage:self.tempImage] progress:nil success:^(NSString *url) {
            NSDictionary *dic = @{@"type":@0,
                                  @"from":@1,
                                  @"url":url};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *tempStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self projectUpdate:@{@"pid":self.project_id,
                                      @"name":self.name,
                                      @"logo":tempStr}];//有logo
            });
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }];
    }
}

- (void)projectUpdate:(NSDictionary *)dic {
    ProjectUpdateApi *api = [[ProjectUpdateApi alloc] init];
    api.requestArgument = dic;
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectUpdateApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectUpdateApi:%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
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
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    //    imagePickerVc.selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr]; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.tempImage = [self getNewImage:[photos firstObject]];
        [self.contentTable reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
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
        [self.contentTable reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 跳转微信加成员
- (void)handleAddMember {
    [self.contentTable endEditing:YES];
    if ([Common isEmptyString:self.project_id]) {
        [super showText:@"请输入项目名称" afterSeconds:1.0];
        return;
    }
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
    
    NSString *subString = [Common encyptWithDictionary:@{@"project_id":self.project_id}];
    NSString *composeURL = [NSString stringWithFormat:@"%@?%@",kLinkURL, subString];
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
