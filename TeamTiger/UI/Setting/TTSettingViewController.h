//
//  TTSettingViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/7/27.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"


@interface TTSettingViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView *contentTable;
@property (strong, nonatomic) TT_Project *project;
@property (copy, nonatomic) void(^requestData)();

@end
