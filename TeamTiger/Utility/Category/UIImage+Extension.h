//
//  UIImage+Extension.h
//  TeamTiger
//
//  Created by Dale on 16/11/29.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/*
 *
 *  压缩图片至目标尺寸
 *
 *  @param sourceImage 源图片
 *  @param targetWidth 图片最终尺寸的宽
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

@end
