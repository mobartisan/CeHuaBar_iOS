//
//  TTMyModifyViewController.h
//  TeamTiger
//
//  Created by Dale on 16/9/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"


@interface TTMyModifyViewController : TTBaseViewController

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *tempDic;
@property (copy, nonatomic) void(^PassValue)(NSString *value);

@end
