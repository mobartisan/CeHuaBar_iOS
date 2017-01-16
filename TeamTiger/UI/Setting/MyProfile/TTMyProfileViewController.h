//
//  TTMyProfileViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTMyProfileViewController : TTBaseViewController <UITableViewDelegate,UITableViewDataSource>

@property(weak,nonatomic)IBOutlet UITableView *tableView;

@end
