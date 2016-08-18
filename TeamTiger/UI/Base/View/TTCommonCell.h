//
//  TTCommonCell.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTCommonItem;
@interface TTCommonCell : UITableViewCell
@property (nonatomic, strong) TTCommonItem *item;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView WithCustomView:(UIView *)customView;
@end
