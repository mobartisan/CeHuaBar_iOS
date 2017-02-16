//
//  DiscussViewController.h
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
#import "STPushView.h"

@interface DiscussViewController : TTBaseViewController

@property (nonatomic,strong) TT_Message *messageModel;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *idDictionary;


@end
