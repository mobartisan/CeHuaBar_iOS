//
//  AddImageView.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "AddImageView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "SelectPhotosManger.h"
#import "UITextView+PlaceHolder.h"

static const double kMargin = 4.0f;
static const double kColumn = 4.0f;
@interface AddImageView ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
    
}


@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *optionLab;
@property (nonatomic, strong) UIButton *addVoteItemBtn;
@property (nonatomic, assign) AddImageViewType addImageViewType;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  textView
 */
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation AddImageView
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.viewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.viewController.navigationController.navigationBar.tintColor;
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

- (UIViewController *)viewController {
    if (!_viewController) {
        _viewController = [self getCurrentVC];
    }
    return _viewController;

}

- (UIViewController *)getCurrentVC {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (instancetype)addImageViewWithType:(AddImageViewType)type AndOption:(NSString *)option{
//    AddImageView *addImageView = [[AddImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    AddImageView *addImageView = [[AddImageView alloc] init];
    if (option != nil) {
        addImageView.optionStr = option;
    }
    
    addImageView.backgroundColor = kColorForCommonCellBackgroud;
    addImageView.addImageViewType = type;
    return addImageView;
}

+ (instancetype)addImageView {
    AddImageView *addImageView = [[AddImageView alloc] init];
    return addImageView;
}

- (void)setAddImageViewType:(AddImageViewType)addImageViewType {
    _addImageViewType = addImageViewType;
    [self configUIWith:addImageViewType];
}

- (void)setOptionStr:(NSString *)optionStr {
    _optionStr = optionStr;
        _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:optionStr];
        _selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:optionStr];
}

- (void)configUIWith:(AddImageViewType)addImageViewType{
    if (addImageViewType == AddImageViewDefual) {
        [self addSubview:self.typeLab];
        self.typeLab.text = @"添加图片";
        
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kDistanceToVSide);
            make.left.equalTo(self).offset(kDistanceToHSide);
            make.width.mas_greaterThanOrEqualTo(40);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeLab.mas_bottom).offset(kDistanceToVSide);
            make.left.equalTo(self).offset(kDistanceToHSide);
            make.right.equalTo(self).offset(-kDistanceToHSide);
            make.bottom.equalTo(self).offset(-kDistanceToVSide);
            make.height.mas_equalTo((Screen_Width - 2 * kDistanceToHSide - 4) / kColumn);
        }];
    }
    if (addImageViewType == AddImageViewVote) {
                
        [self addSubview:self.optionLab];
        self.optionLab.text = [NSString stringWithFormat:@"选项%@:", self.optionStr];
        [self.optionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self).offset(kDistanceToHSide+4);
            make.width.mas_greaterThanOrEqualTo(60);
            //            make.height.mas_equalTo(kLabelHeight);
            make.top.equalTo(self);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-kDistanceToVSide*0.2);
        }];

        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self).offset(kDistanceToHSide * 4);
            make.right.equalTo(self).offset(-kDistanceToHSide);
            make.top.equalTo(self);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-kDistanceToVSide*0.2);
        }];
        self.textView.placeholder = @"输入选项描述";
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.equalTo(self.typeLab.mas_bottom).offset(kDistanceToVSide);
            make.left.equalTo(self).offset(kDistanceToHSide);
            make.right.equalTo(self).offset(-kDistanceToHSide);
            make.bottom.equalTo(self).offset(-kDistanceToVSide*0.5);
            make.height.mas_equalTo((Screen_Width - 2 * kDistanceToHSide - 4) / kColumn);
        }];
    }
    
    if (addImageViewType == AddImageViewVoteWithTitle) {
        
        [self addSubview:self.typeLab];
        [self addSubview:self.optionLab];
        [self addSubview:self.textView];
        self.typeLab.text = @"投票选项";
        self.optionLab.text = @"选项A:";
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kDistanceToVSide);
            make.left.equalTo(self).offset(kDistanceToHSide);
            make.height.mas_equalTo(kLabelHeight);
            make.width.mas_greaterThanOrEqualTo(40);
        }];
        
        [self.optionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self).offset(kDistanceToHSide+4);
            make.width.mas_greaterThanOrEqualTo(60);
//            make.height.mas_equalTo(kLabelHeight);
            make.top.equalTo(self.typeLab.mas_bottom).offset(kDistanceToVSide*0.2);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-kDistanceToVSide*0.2);
        }];
        
        self.textView.placeholder = @"输入选项描述";
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self).offset(kDistanceToHSide * 4.0);
            make.right.equalTo(self).offset(-kDistanceToHSide);
            make.top.equalTo(self.typeLab.mas_bottom).offset(kDistanceToVSide*0.2);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-kDistanceToVSide*0.2);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.equalTo(self.typeLab.mas_bottom).offset(kDistanceToVSide);
            make.left.equalTo(self).offset(kDistanceToHSide);
            make.right.equalTo(self).offset(-kDistanceToHSide);
            make.bottom.equalTo(self).offset(-kDistanceToVSide*0.5);
            make.height.mas_equalTo((Screen_Width - 2 * kDistanceToHSide - 4) / kColumn);
        }];
    }
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = kColorForCommonCellBackgroud;

        [self configCollectionView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = kColorForCommonCellBackgroud;
//        _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoes];
//        _selectedAssets = [[SelectPhotosManger sharedInstance] getAssets];
//        [self addSubview:self.typeLab];
//        [self configCollectionView];
//    }
//    return self;
//}

- (void)configCollectionView {
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = kMargin;
    _itemWH = (Screen_Width - 2 * kDistanceToHSide - 4) / kColumn - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, (Screen_Width - 2 * kDistanceToHSide - 4) / kColumn - kMargin) collectionViewLayout:_layout];
    //    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    //    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.backgroundColor = [UIColor clearColor];
//    _collectionView.backgroundColor = [UIColor yellowColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.tintColor = [UIColor whiteColor];
        _textView.maxLength = 200;//最大字数
    }
    return _textView;
    
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:17];
        _typeLab.textColor = [UIColor whiteColor];
    }
    return _typeLab;
}

- (UILabel *)optionLab {
    if (!_optionLab) {
        _optionLab = [[UILabel alloc] init];
        _optionLab.font = [UIFont systemFontOfSize:15];
        _optionLab.textColor = [UIColor whiteColor];
    }
    return _optionLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat contentSizeH = self.collectionView.contentSize.height;
//    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.height.mas_equalTo(contentSizeH);
//    }];

}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.hidden = NO;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        if (_selectedAssets.count == kMaxImagesCount) {
            cell.hidden = YES;
        }
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        WeakSelf;
        UIActionSheet *sheet = [UIActionSheet hyb_showInView:[wself viewController].view title:nil cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"拍照",@"去相册选择"] callback:^(UIActionSheet *actionSheet, NSUInteger buttonIndex) {
            if (buttonIndex == 0) { // take photo / 去拍照
                [wself takePhoto];
            } else if (buttonIndex == 1) {
                [wself pushImagePickerController];
            }
        }];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [[self viewController] presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            //            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                [[SelectPhotosManger sharedInstance] setSelectPhotoes:[NSMutableArray arrayWithArray:photos] WithOption:self.optionStr];
                [[SelectPhotosManger sharedInstance] setSelectAssets:[NSMutableArray arrayWithArray:assets]WithOption:self.optionStr];
                _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:self.optionStr];
                _selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                _layout.itemCount = _selectedPhotos.count;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
//    UIImage *image = _selectedPhotos[sourceIndexPath.item];
//    if (image) {
//        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//        [_collectionView reloadData];
//    }
//}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr]; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
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
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
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
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [[self viewController] presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        //        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    //                    [_selectedAssets addObject:assetModel.asset];
                    //                    [_selectedPhotos addObject:image];
                    [[SelectPhotosManger sharedInstance] addAsset:assetModel.asset WithOption:self.optionStr];
                    [[SelectPhotosManger sharedInstance] addImage:image WithOption:self.optionStr];
                    _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:self.optionStr];
                    _selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr];
                    [_collectionView reloadData];
                }];
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [[SelectPhotosManger sharedInstance] setSelectPhotoes:[NSMutableArray arrayWithArray:photos] WithOption:self.optionStr];
    [[SelectPhotosManger sharedInstance] setSelectAssets:[NSMutableArray arrayWithArray:assets] WithOption:self.optionStr];
    _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:self.optionStr];
    _selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr];
    //    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    //    [_selectedPhotos removeObjectAtIndex:sender.tag];
    //    [_selectedAssets removeObjectAtIndex:sender.tag];
    [[SelectPhotosManger sharedInstance] deleteAssetWithIndex:sender.tag WithOption:self.optionStr];
    [[SelectPhotosManger sharedInstance] deletePhotoeWithIndex:sender.tag WithOption:self.optionStr];
    _selectedPhotos = [[SelectPhotosManger sharedInstance] getPhotoesWithOption:self.optionStr];
    _selectedAssets = [[SelectPhotosManger sharedInstance] getAssetsWithOption:self.optionStr];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    UITableView *tableView = [self tableView];
    CGPoint currentOffset = tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [tableView setContentOffset:currentOffset animated:NO];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

#pragma mark - Override

#pragma mark - Initial Methods

#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource


#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
