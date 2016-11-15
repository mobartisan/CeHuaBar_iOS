//
//  SelectBgImageVC.h
//  TeamTiger
//
//  Created by 刘鵬 on 2016/11/15.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
@class SelectBgImageVC;
typedef void(^SelectBgImageVCBlock)(UIImage *selectImage, SelectBgImageVC *selectBgImageVC);
@interface SelectBgImageVC : TTBaseViewController

@property (nonatomic, copy)SelectBgImageVCBlock selectCircleVCBlock;

@end
