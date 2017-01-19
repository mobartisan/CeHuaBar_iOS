//
//  CJGroupCell.h
//  TeamTiger
//
//  Created by Dale on 17/1/12.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TT_Group;
typedef NS_ENUM(int, CJGroupCellClickType) {
    CJGroupCellClickTypeText = 0,
    CJGroupCellClickTypeBtn
};


@interface CJGroupCell : UITableViewCell

@property (strong, nonatomic) TT_Group *group;
@property (assign, nonatomic, getter=isLastRow) BOOL lastRow;
@property (nonatomic,copy) void(^actionBlcok)(CJGroupCellClickType type, NSString *text);

@end
