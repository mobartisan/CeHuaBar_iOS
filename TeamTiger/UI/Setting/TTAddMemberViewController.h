//
//  TTAddMemberViewController.h
//  TeamTiger
//
//  Created by Dale on 17/2/3.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

@interface TTAddMemberViewController : TTBaseViewController

@property (nonatomic,strong) TT_Project *project;
@property (nonatomic,strong) NSMutableArray *members;//项目成员数组
@property (nonatomic,copy) void(^addMemberBlock)();


@end
