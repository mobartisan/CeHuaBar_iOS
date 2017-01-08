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

@interface TTAddProjectViewController ()<WXApiManagerDelegate, TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (copy, nonatomic) NSString *name;
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
//                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"",@"TYPE":@"2"},
//                  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"",@"TYPE":@"3"},
                  
                  //                  @{@"NAME":@"ffgfgfgfgfgfgfggf大大大大大大大大大大大大",@"TITLE":@"描述",@"TYPE":@"1"},
                  //                  @{@"NAME":@"飞凤飞飞如果认购人跟人沟通",@"TITLE":@"私有",@"TYPE":@"2"},
                  @{@"NAME":@"",@"TITLE":@"",@"TYPE":@"4"},nil];
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
        cell.projectIcon.image = [self.tempImage imageWithImageSimple:self.tempImage scaledToSize:CGSizeMake(45, 45)];
    }
    //创建按钮
    if ([Common isEmptyString:self.name]) {
        [cell.createBtn setTitle:@"创建" forState:UIControlStateNormal];
        cell.textField.text = nil;
        cell.textField.textAlignment = NSTextAlignmentLeft;
    } else {
        [cell.createBtn setTitle:@"完成" forState:UIControlStateNormal];
        cell.textField.text = self.name;
        cell.textField.textAlignment = NSTextAlignmentRight;
    }
    cell.actionBlock = ^(SettingCell *settingCell, ECellType type, id obj){
        switch (type) {
            case ECellTypeProjectIcon:{
                [self.contentTable endEditing:YES];
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
            case ECellTypeSearch:{
                [self userSearch:obj];
                break;
            }
            case ECellTypeAddMember:{
                [self.datas removeObjectAtIndex:2];
                [self.datas insertObject: @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"",@"TYPE":@"2"} atIndex:2];
                [self.contentTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case ECellTypeBottom:{
                if ([[settingCell.createBtn titleForState:UIControlStateNormal] isEqualToString:@"创建"]) {
                    [self createProjectWithProjectName:self.name];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
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
        return 10;
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
        return memberCount * kCellHeight;
        
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
        return footerView;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 创建项目
- (void)createProjectWithProjectName:(NSString *)name {
    if ([Common isEmptyString:name]) {
        [super showText:@"项目名称不能为空" afterSeconds:1.0];
        return;
    }
    if (self.tempImage == nil || [self.tempImage isEqual:[NSNull null]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self projectCreat:name tempDic:[NSDictionary dictionary]];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIImage *image = [self.tempImage normalizedImage];
        [QiniuUpoadManager uploadImage:self.tempImage progress:nil success:^(NSString *url) {
            NSDictionary *dic = @{@"type":@0,
                                  @"from":@1,
                                  @"url":url};
            dispatch_async(dispatch_get_main_queue(), ^{
                [self projectCreat:name tempDic:dic];
            });
        } failure:^(NSError *error) {
            [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
        }];
    }
    
}

- (void)projectCreat:(NSString *)projectName tempDic:(NSDictionary *)dic{
    NSLog(@"isMainThread:%zd", [NSThread currentThread].isMainThread);
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.selectMembers options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    ProjectCreateApi *projectCreateApi = [[ProjectCreateApi alloc] init];
    projectCreateApi.requestArgument = @{@"logo":dic,
                                         @"name":projectName,
                                         @"uids":memberStr,//假设项目中有可以添加的成员,如果有,uids表示所有成员的
                                         };
    [projectCreateApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"ProjectCreateApi:%@", request.responseJSONObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:request.responseJSONObject[MSG] afterSeconds:1.0];
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            self.project_id = request.responseJSONObject[OBJ][@"pid"];
          
            [self.datas insertObject:@{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"添加成员",@"TYPE":@"3"} atIndex:2];
            [self.contentTable reloadData];
            
            [[CirclesManager sharedInstance] loadingGlobalCirclesInfo];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"ProjectCreateApi:%@",error.description);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [super showText:@"您的网络好像有问题~" afterSeconds:1.0];
    }];
}

#pragma mark - 模糊搜索
- (void)userSearch:(NSString *)key {
    if ([Common isEmptyString:key]) {
        [super showText:@"请输入搜索关键字" afterSeconds:1.0];
        return;
    }
    self.membersArray = [NSMutableArray array];
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
        } else {
            [super showText:@"暂无该人员信息" afterSeconds:1.0];
        }
        [self.contentTable reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [super showText:@"您的网络有问题~" afterSeconds:1.0];
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
        self.tempImage = [photos firstObject];
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
        self.tempImage = image;
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
        [super showText:@"请先创建项目" afterSeconds:1.0];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
}

@end
