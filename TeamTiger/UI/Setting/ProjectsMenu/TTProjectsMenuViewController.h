//
//  TTProjectsMenuViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTProjectsMenuViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak)IBOutlet UITableView *menuTable;

@property(nonatomic, strong) NSMutableArray *allDatas;

@property(nonatomic, strong) NSMutableArray *projects;

@property(nonatomic, strong) NSMutableArray *groups;

@end
