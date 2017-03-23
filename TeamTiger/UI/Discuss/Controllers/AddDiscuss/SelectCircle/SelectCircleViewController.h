//
//  SelectCircleViewController.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
@class SelectCircleViewController;
typedef void(^SelectCircleVCBlock)(id selectTitle, SelectCircleViewController *selectCircleVC);

@interface SelectCircleViewController : TTBaseViewController

//@property (nonatomic, copy)SelectCircleVCBlock selectCircleVCBlock;
@end
