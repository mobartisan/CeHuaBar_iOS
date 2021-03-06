//
//  DiVideGroupCell.h
//  TeamTiger
//
//  Created by Dale on 16/12/26.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiVideGroupCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightOfProjectsView:(NSArray *)projects;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) void(^clickAddGroupBlock)();//添加分组
@property (copy, nonatomic) void(^clickGroupBlock)(TT_Group *group);//点击分组
@property (copy, nonatomic) void(^longPressItemBlock)();//长按删除
@property (copy, nonatomic) void (^clickDeleteBtnBlock)(TT_Group *group);//删除按钮

@end
