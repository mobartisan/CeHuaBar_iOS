//
//  NotificationCell.h
//  TeamTiger
//
//  Created by xxcao on 16/8/17.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFadeSwitch.h"

@interface NotificationCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLab;

@property(nonatomic,strong)UILabel *contentLab;

@property (strong, nonatomic) TTFadeSwitch *tSwitch;

- (void)reloadCellData:(id)obj;

@end
