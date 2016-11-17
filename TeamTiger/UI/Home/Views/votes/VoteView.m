//
//  VoteView.m
//  TeamTiger
//
//  Created by Dale on 16/11/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "VoteView.h"
#import "UIView+SDAutoLayout.h"
#import "ImageAndBtnView.h"
#import "JJPhotoManeger.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface VoteView ()<JJPhotoDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (strong, nonatomic) NSMutableArray *imageArr;
@end

@implementation VoteView


- (NSMutableArray *)imageArr {
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        ImageAndBtnView *customView = [ImageAndBtnView new];
        customView.imageV.tag = i;
        [self addSubview:customView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [customView.imageV addGestureRecognizer:tap];
        [temp addObject:customView];
        
    }
    
    self.imageViewsArray = [temp copy];
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray {
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
       ImageAndBtnView *customView  = [self.imageViewsArray objectAtIndex:i];
        customView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0.0;
    if (is40inch) {
        itemH = 100;
    }else {
        itemH = 120;
    }
    //    if (_picPathStringsArray.count == 1) {
    //        UIImage *image = [UIImage imageNamed:_picPathStringsArray.firstObject];
    //        if (image.size.width) {
    //            itemH = image.size.height / image.size.width * itemW;
    //        }
    //    } else {
    //        itemH = itemW;
    //    }
    NSArray *arr = @[@"A", @"B", @"C"];
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin  =  7;
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        ImageAndBtnView *customView  = [_imageViewsArray objectAtIndex:idx];
        customView.projectLB.text = arr[idx];
        customView.hidden = NO;
        customView.imageV.image = [UIImage imageNamed:obj];
        customView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        [self.imageArr addObject:customView.imageV];
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    //3.14 ceilf(3.14) = 4
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

//每张图片的宽度
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array {
    CGFloat maxWidth = 0.0;
//    if (is40inch) {
//        maxWidth = 50;
//    }else if (is47inch) {
//        maxWidth = 72;
//    }else if (is55inch) {
//        maxWidth = 75;
//    }
    if (is40inch || is47inch) {
        maxWidth = (kScreenWidth - 67 - 25 - 14) / 3;
    }else {
        maxWidth = 102.1;
    }
    return maxWidth;
}

//每行图片的个数
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    //    if (array.count <= 3) {
    //        return array.count;
    //    } else if (array.count <= 4) {
    //        return 2;
    //    } else {
    //        return 3;
    //    }
    return 3;
    
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    [_textField endEditing:YES];
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *manager = [JJPhotoManeger maneger];
    manager.delegate = self;
    [manager showNetworkPhotoViewer:self.imageArr urlStrArr:nil selecView:view content:self.content];
    
}

#pragma mark - JJPhotoDelegate
//关闭PhotoViewer时调用并返回 (观看的最后一张图片的序号)
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex {
    NSLog(@"%ld", selecedImageViewIndex);
}

@end
