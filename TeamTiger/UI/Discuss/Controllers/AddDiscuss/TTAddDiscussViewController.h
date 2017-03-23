//
//  TTAddDiscussViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTAddDiscussViewController : TTBaseViewController

@property (copy, nonatomic) void (^addDiscussBlock)(NSString *pid, NSString *name);

@property (copy, nonatomic) NSString *pidOrGid;

@end
