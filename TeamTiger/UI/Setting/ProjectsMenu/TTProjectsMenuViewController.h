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

@property(nonatomic, strong) IBOutlet UIView *infoView;
@property(nonatomic, strong) IBOutlet UIImageView *headImgV;
@property(nonatomic, strong) IBOutlet UILabel *nameLab;
@property(nonatomic, strong) IBOutlet UILabel *remarkLab;


@end
