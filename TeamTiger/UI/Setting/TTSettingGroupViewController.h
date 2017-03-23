//
//  TTSettingGroupViewController.h
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTSettingGroupViewController : TTBaseViewController
@property (nonatomic,copy) NSString *project_id;
@property (nonatomic,copy) void(^selectGroup)(NSString *groupName);

@end
