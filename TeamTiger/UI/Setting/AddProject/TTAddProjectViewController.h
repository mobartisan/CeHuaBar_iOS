//
//  TTAddProjectViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

@interface TTAddProjectViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTable;

@property (strong, nonatomic)NSMutableArray *datas;

@property (copy, nonatomic) void (^creatProjectSuccess)(BOOL isSuccess);

@end
