//
//  TTTabBarViewController.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTTabBarViewController.h"
#import "HomeViewController.h"
// Controllers

// Model

// Views
//#define <#macro#> <#value#>

@interface TTTabBarViewController ()
@property (nonatomic, strong) NSMutableArray *tt_ChildViewControllers;
@end
#pragma mark - View Controller LifeCyle
@implementation TTTabBarViewController
- (instancetype)initWithChildViewControllers:childViewControllers
{
    if (self = [super init]) {
        self.tt_ChildViewControllers = [NSMutableArray arrayWithArray:childViewControllers];
        // 初始化所有的子控制器
        [self setupAllChildViewControllers];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBar removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Override

#pragma mark - Initial Methods
/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    for (HomeViewController *homeVC in self.tt_ChildViewControllers) {
        [self setupChildViewController:homeVC title:homeVC.title imageName:nil selectedImageName:nil];
    }
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 2.包装一个导航控制器
    TTBaseNavigationController *nav = [[TTBaseNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


#pragma mark - Target Methods
- (void)addChildViewController {

}

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
