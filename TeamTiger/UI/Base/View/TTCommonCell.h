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
@property (copy, nonatomic) void (^actionBlock)(NSString *text);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView isReuse:(BOOL)isReuse;

@end
