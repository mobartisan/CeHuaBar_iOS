//
//  TTSelectGroupViewController.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/12.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@class TTSelectGroupViewController;

typedef void(^SelectGroupBlock)(TTSelectGroupViewController *selectGroupVC, NSMutableDictionary *groupDic);

@interface TTSelectGroupViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *groupTable;

@property(nonatomic, strong) NSMutableArray *groupDatas;

@property(nonatomic, copy) SelectGroupBlock selectGroupBlock;

@property(nonatomic, assign)NSInteger currentSelectedIndex;

@property(nonatomic, strong)NSMutableDictionary *selectedGroup;

@end
