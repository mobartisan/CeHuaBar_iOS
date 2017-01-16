//
//  TTGroupViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

@interface TTGroupSettingViewController : TTBaseViewController

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) NSMutableArray *projects;
@property (strong, nonatomic) TT_Group *group;
@property (copy, nonatomic) void(^requestData)();

@end
