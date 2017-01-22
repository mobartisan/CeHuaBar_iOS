//
//  TTGroupViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/11/3.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

typedef NS_ENUM(int, ExitType) {
    ExitTypeDelete = 0,//点击删除并退出
    ExitTypeModify//修改组名
};

@interface TTGroupSettingViewController : TTBaseViewController

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) NSMutableArray *projects;
@property (strong, nonatomic) TT_Group *group;
@property (copy, nonatomic) void(^requestData)(NSString *groupName, ExitType type);

@end
