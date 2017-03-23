//
//  TTAddVoteViewController.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTAddVoteViewController : TTBaseViewController

@property (copy, nonatomic) void(^addVoteBlock)(NSString *pid, NSString *name);
@property (copy, nonatomic) NSString *pidOrGid;

@end
