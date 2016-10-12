//
//  TTSelectGroupViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/12.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTSelectGroupViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *groupTable;

@property(nonatomic, strong) NSMutableArray *groupDatas;

@end
