//
//  SelectCircleViewController.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
@class SelectCircleViewControllerForSetting;
typedef void(^SelectCircleVCBlock)(id selectObj, SelectCircleViewControllerForSetting *selectCircleVC);

@interface SelectCircleViewControllerForSetting : TTBaseViewController

@property (nonatomic, copy)SelectCircleVCBlock selectCircleVCBlock;

@end
