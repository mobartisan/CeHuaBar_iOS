//
//  GroupCell.h
//  TeamTiger
//
//  Created by xxcao on 2016/12/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupCell;

typedef void(^EndEditBlock)(GroupCell *cell, NSString *nameStr);

@interface GroupCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UITextField *nameTxtField;

@property(nonatomic, copy)EndEditBlock endEditBlock;

@end
