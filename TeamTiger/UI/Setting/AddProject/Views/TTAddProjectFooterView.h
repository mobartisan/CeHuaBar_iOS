//
//  TTAddProjectFooterView.h
//  TeamTiger
//
//  Created by Dale on 17/1/5.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 60.0

@interface TTAddProjectFooterView : UIView

@property (strong, nonatomic) NSMutableArray * dataSource;
@property (strong, nonatomic) NSMutableArray *selectMembers;
@property (copy, nonatomic) void (^addMemberBlock)(NSMutableArray *selectMembers);

@end
