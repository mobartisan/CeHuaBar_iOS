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
 *  @param image 源图片
 *  @param newSize 图片最终尺寸的宽, 高
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的图片
 */
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;

- (UIImage *)normalizedImage;

- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size;

<<<<<<< HEAD
+(NSData *)imageData:(UIImage *)myimage;
=======
- (UIImage *)fixOrientation:(UIImage *)aImage;

- (NSData *)zipImageWithImage;//压图片

- (UIImage *)compressImageWithNewWidth:(CGFloat)newImageWidth;//缩图片
>>>>>>> origin/master

@end
