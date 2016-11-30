//
//  UIImage+Extension.h
//  TeamTiger
//
//  Created by Dale on 16/11/29.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

@end
