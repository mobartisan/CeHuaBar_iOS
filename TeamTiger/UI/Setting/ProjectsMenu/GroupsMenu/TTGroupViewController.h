//
//  TTGroupViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

@interface TTGroupViewController : TTBaseViewController

@property(nonatomic, strong) UITableView *table;

@property(nonatomic, strong) NSMutableArray *projects;

@property(nonatomic, copy) NSString *groupId;

@property (copy, nonatomic) NSString *gid;

@property (strong, nonatomic) NSMutableArray *allGroups;

@end
