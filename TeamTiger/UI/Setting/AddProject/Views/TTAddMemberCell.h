//
//  TTAddMemberCell.h
//  TeamTiger
//
//  Created by Dale on 17/1/5.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TT_User;

@interface TTAddMemberCell : UITableViewCell

@property (strong, nonatomic) TT_User *user;

@property (weak, nonatomic) IBOutlet UIImageView *icon_confirm;
@property (nonatomic,copy) void (^selectBtnBlock)();

@end
