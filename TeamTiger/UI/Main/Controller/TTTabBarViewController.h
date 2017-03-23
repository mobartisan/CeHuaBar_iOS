//
//  TTTabBarViewController.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTabBarViewController : UITabBarController
//@property (nonatomic, strong) NSMutableArray *tt_ChildViewControllers;

-(instancetype)initWithChildViewControllers:(NSMutableArray *)childViewControllers;

-(void)addChildViewController;
@end
