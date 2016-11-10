//
//  VoteView.m
//  TeamTiger
//
//  Created by Dale on 16/11/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "VoteView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "ImageAndBtnView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface VoteView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation VoteView


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


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
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
    CGFloat itemH = 120;
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
        
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = imageView.superview;
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    //    if (array.count == 1) {
    //        return 120;
    //    } else {
    //        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
    //        return w;
    //    }
    
    CGFloat maxWidth = 0.0;
    if (is40inch) {
        maxWidth = 50;
    }else if (is47inch) {
        maxWidth = 72;
    }else if (is55inch) {
        maxWidth = 75;
    }
    return  (kScreenWidth - 67 - 25 - 14) / 3;
}

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


#pragma mark - SDPhotoBrowserDelegate

//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    NSString *imageName = self.picPathStringsArray[index];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
//    return url;
//}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    ImageAndBtnView  *customView = self.subviews[index];
    UIImageView *imageView = (UIImageView *)[customView viewWithTag:index];
    NSLog(@"%@", imageView);
    return imageView.image;
}


@end
